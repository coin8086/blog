---
title: Is Bigger Smarter?
date: 2013-06-07T16:56:34+00:00
layout: post
categories:
  - 编程挑战
---
PC/UVa IDs: 111101/10131 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;category=39&#038;problem=1072&#038;mosmsg=Submission+received+with+ID+11870299" target="_blank">题目描述</a>

分析：此题同<a href="http://kuangtong.net/archives/209" title="Edit Step Ladders" target="_blank">Edit Step Ladders</a>类似（至少在解法思路上很相似）：把大象按体重递增排序，然后从排序后的最后一只大象开始向前“反攻倒算”，总的时间复杂度在O(n^2)。<!--more-->

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;algorithm&gt;

using namespace std;

class Elephant {
public:
  Elephant() {}

  Elephant(int aw, int as, int ai) : w(aw), s(as), i(ai) {}

  bool operator &lt;(const Elephant & e) const {
    return w &lt; e.w;
  }

  int w;  //weight
  int s;  //smartness
  int i;  //order
};

class Result {
public:
  Result() : max(0), next(0) {}

  bool operator &lt;(const Result & r) const {
    return max &lt; r.max;
  }

  int max;  //max number of elephant in seq
  int next; //next elephant number in seq
};

vector&lt;int&gt; max_seq(vector&lt;Elephant&gt; & ele) {
  int n = ele.size();
  vector&lt;Result&gt; results(n);
  sort(ele.begin(), ele.end());
  results[n - 1].max = 1;
  for (int i = n - 2; i &gt;= 0; i--) {
    Elephant & e = ele[i];
    int max = 0;
    int maxi = 0;
    for (int k = i + 1; k &lt; n; k++) {
      Elephant & e2 = ele[k];
      if (e.w &lt; e2.w && e.s &gt; e2.s && max &lt; results[k].max) {
        max = results[k].max;
        maxi = k;
      }
    }
    results[i].max = max + 1;
    results[i].next = maxi;
  }
  //build path
  vector&lt;Result&gt;::iterator it = max_element(results.begin(), results.end());
  int next = it-&gt;next;
  vector&lt;int&gt; r;
  r.push_back(ele[it - results.begin()].i);
  while (next) {
    r.push_back(ele[next].i);
    next = results[next].next;
  }
  return r;
}

int main() {
  int w, s;
  int c = 0;
  vector&lt;Elephant&gt; ele;
  while (cin &gt;&gt; w &gt;&gt; s) {
    ele.push_back(Elephant(w, s, ++c));
  }
  vector&lt;int&gt; seq = max_seq(ele);
  cout &lt;&lt; seq.size() &lt;&lt; endl;
  for (int i = 0; i &lt; seq.size(); i++)
    cout &lt;&lt; seq[i] &lt;&lt; endl;
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_30">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F07%2Fis-bigger-smarter%2F&linkname=Is%20Bigger%20Smarter%3F" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F07%2Fis-bigger-smarter%2F&linkname=Is%20Bigger%20Smarter%3F" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F07%2Fis-bigger-smarter%2F&linkname=Is%20Bigger%20Smarter%3F" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F07%2Fis-bigger-smarter%2F&linkname=Is%20Bigger%20Smarter%3F" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>