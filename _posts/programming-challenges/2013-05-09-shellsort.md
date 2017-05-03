---
title: ShellSort
date: 2013-05-09T21:25:01+00:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110407/10152 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&page=show_problem&problem=1093" target="_blank">题目描述</a>

<!--more-->

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;string&gt;
#include &lt;vector&gt;
#include &lt;algorithm&gt;

using namespace std;

vector&lt;string&gt; shell_sort(vector&lt;string&gt; & old_order, vector&lt;string&gt; & new_order) {
  vector&lt;string&gt; steps;
  vector&lt;string&gt;::iterator end = old_order.end();
  vector&lt;string&gt;::iterator prev = end;
  for (int i = 0; i &lt; new_order.size() - 1; i++) {
    string & s1 = new_order[i];
    string & s2 = new_order[i + 1];
    vector&lt;string&gt;::iterator it1 = (prev == end ? find(old_order.begin(), end, s1) : prev);
    vector&lt;string&gt;::iterator it2 = find(old_order.begin(), old_order.end(), s2);
    if (it1 &gt; it2) {
      old_order.erase(it2);
      old_order.push_back(s2);
      steps.push_back(s2);
      prev = end - 1;
    }
    else {
      prev = it2;
    }
  }
  return steps;
}

int main() {
  int k = 0;
  cin &gt;&gt; k;
  for (int i = 0; i &lt; k; i++) {
    int n = 0;
    cin &gt;&gt; n;
    string line;
    getline(cin, line); //skip empty line
    int j;
    vector&lt;string&gt; old_order;
    for (j = 0; j &lt; n; j++) {
      getline(cin, line);
      old_order.push_back(line);
    }
    reverse(old_order.begin(), old_order.end());
    vector&lt;string&gt; new_order;
    for (j = 0; j &lt; n; j++) {
      getline(cin, line);
      new_order.push_back(line);
    }
    reverse(new_order.begin(), new_order.end());
    vector&lt;string&gt; steps = shell_sort(old_order, new_order);
    for (j = 0; j &lt; steps.size(); j++) {
      cout &lt;&lt; steps[j] &lt;&lt; endl;
    }
    cout &lt;&lt; endl;
  }
}
</pre>

