---
title: 'Stack&#8217;em Up'
date: 2013-05-03T23:42:34+00:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa 题号：110205/10205 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&page=show_problem&problem=1146" target="_blank">题目描述</a><!--more-->

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;string&gt;
#include &lt;cstdlib&gt;

using namespace std;

const char * values[] = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"};
const char * suits[] = {"Clubs", "Diamonds", "Hearts", "Spades"};

vector&lt;int&gt; shuffle(const vector&lt;int&gt; & cards, const vector&lt;int&gt; & order) {
  vector&lt;int&gt; r(cards.size());
  for (int i = 0; i &lt; order.size(); i++) {
    r[i] = cards[order[i]];
  }
  return r;
}

void output(const vector&lt;int&gt; & cards) {
  for (int i = 0; i &lt; cards.size(); i++) {
    int v = cards[i] % 13;
    int s = cards[i] / 13;
    cout &lt;&lt; values[v] &lt;&lt; " of " &lt;&lt; suits[s] &lt;&lt; endl;
  }
}

int main() {
  string line;
  getline(cin, line);
  int n = atoi(line.c_str());
  getline(cin, line); //skip empty line
  for (int i = 0; i &lt; n; i++) {
    int m = 0;
    cin &gt;&gt; m;
    vector&lt;vector&lt;int&gt; &gt; methods(m);
    for (int j = 0; j &lt; m; j++) {
      for (int k = 0; k &lt; 52; k++) {
        int order;
        cin &gt;&gt; order;
        methods[j].push_back(order - 1);
      }
    }
    getline(cin, line); //skip till a new line
    vector&lt;int&gt; cards(52);
    for (int l = 0; l &lt; cards.size(); l++) {
      cards[l] = l;
    }
    while(getline(cin, line)) {
      if (line.empty())
        break;
      int k = atoi(line.c_str()) - 1;
      cards = shuffle(cards, methods[k]);
    }
    output(cards);
    if (i != n - 1)
      cout &lt;&lt; endl;
  }
  return 0;
}
</pre>

