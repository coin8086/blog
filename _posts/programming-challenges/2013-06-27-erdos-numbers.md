---
title: Erdos Numbers
date: 2013-06-27T23:13:27+00:00
layout: post
categories:
  - 编程挑战
---
PC/UVa IDs: 110206/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=985" target="_blank">10044</a>

分析：如果把一个作者看作一个顶点，若两个作者合作发表过一篇论文则对应的两点有一条边相连，那么一个作者的Erdos数就是该点到Erdos点的最短距离。在此图中从Erdos点开始宽度优先遍历即可得解。不过，此题真正困难之处并不在此，<!--more-->而在于如何处理输入！因为题目对于输入格式的说明含混不清，仅举了个例子，且例子也没包括一些特殊情况，所以大家就只能猜了！读者可以参考UVa BBS上的

<a href="http://online-judge.uva.es/board/viewtopic.php?f=9&#038;t=2931&#038;start=15&#038;hilit=Erdos+Numbers" target="_blank">相关讨论</a>，或者试试这个<a href="https://code.google.com/p/programming-challenges-robert/source/browse/ch2_ex6_input" target="_blank">input</a>，对应的<a href="https://code.google.com/p/programming-challenges-robert/source/browse/ch2_ex6_output" target="_blank">output</a>在这里——程序必须通过这样的测试才有可能AC。笔者必须说，此题对输入格式的描述极不严谨，极大地浪费了读者的时间，在这样一本书中实属不该。

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;string&gt;
#include &lt;vector&gt;
#include &lt;map&gt;
#include &lt;set&gt;
#include &lt;queue&gt;
#include &lt;cctype&gt;
#include &lt;climits&gt;

#define ERDOS "Erdos, P."

using namespace std;

typedef map&lt;string, set&lt;string&gt; &gt; Relation;

inline void skip_space(const string & str, int & i) {
  while (isspace(str[i]))
    i++;
}

inline bool is_valid(char ch) {
  return ch && !isspace(ch) && ch != ',';
}

inline string parse_author(const string & line, int start = 0, int * end = 0) {
  string a;
  int i = start;
  skip_space(line, i);
  while (is_valid(line[i]))
    a.push_back(line[i++]);
  skip_space(line, i);
  if (line[i] == ',') {
    a.push_back(',');
    a.push_back(' ');
    i++;
  }
  skip_space(line, i);
  while (is_valid(line[i]))
    a.push_back(line[i++]);
  if (end)
    *end = i;
  return a;
}

inline vector&lt;string&gt; parse_authors(const string & line) {
  vector&lt;string&gt; a;
  string names = line.substr(0, line.find(':'));
  int i = 0;
  int j;
  while (true) {
    string name = parse_author(names, i, &j);
    if (!name.empty())
      a.push_back(name);
    skip_space(names, j);
    if (names[j] == ',')
      j++;
    skip_space(names, j);
    if (!names[j])
      break;
    i = j;
  }
  return a;
}

inline void relate(Relation & r, const vector&lt;string&gt; & authors) {
  int n = authors.size();
  for (int i = 0; i &lt; n; i++) {
    for (int j = i + 1; j &lt; n; j++) {
      r[authors[i]].insert(authors[j]);
      r[authors[j]].insert(authors[i]);
    }
  }
}

vector&lt;int&gt; erdos_numbers(const Relation & r, const vector&lt;string&gt; & authors) {
  vector&lt;int&gt; en(authors.size(), INT_MAX);
  if (r.count(ERDOS)) { //Erdos himself may not in r at all!
    map&lt;string, int&gt; stat;
    queue&lt;string&gt; q;
    stat[ERDOS] = 0;
    q.push(ERDOS);
    while (!q.empty()) {
      string author = q.front();
      q.pop();
      int n = stat[author];
      const set&lt;string&gt; & coauthors = r.at(author);
      set&lt;string&gt;::const_iterator it = coauthors.begin();
      for (; it != coauthors.end(); it++) {
        if (!stat.count(*it)) {
          stat[*it] = n + 1;
          q.push(*it);
        }
      }
    }
    for (int i = 0; i &lt; authors.size(); i++) {
      map&lt;string, int&gt;::iterator it = stat.find(authors[i]);
      if (it != stat.end())
        en[i] = it-&gt;second;
    }
  }
  return en;
}

int main() {
  int N = 0;
  cin &gt;&gt; N;
  for (int i = 1; i &lt;= N; i++) {
    int p, n;
    cin &gt;&gt; p &gt;&gt; n;
    Relation r;
    string line;
    getline(cin, line); //Skip empty line
    int j;
    for (j = 0; j &lt; p; j++) {
      getline(cin, line);
      relate(r, parse_authors(line));
    }
    vector&lt;string&gt; authors;
    authors.reserve(n);
    for (j = 0; j &lt; n; j++) {
      getline(cin, line);
      authors.push_back(parse_author(line));
    }
    vector&lt;int&gt; en = erdos_numbers(r, authors);
    cout &lt;&lt; "Scenario " &lt;&lt; i &lt;&lt; endl;
    for (j = 0; j &lt; n; j++) {
      cout &lt;&lt; authors[j] &lt;&lt; ' ';
      if (en[j] == INT_MAX)
        cout &lt;&lt; "infinity";
      else
        cout &lt;&lt; en[j];
      cout &lt;&lt; endl;
    }
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_51">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F27%2Ferdos-numbers%2F&linkname=Erdos%20Numbers" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F27%2Ferdos-numbers%2F&linkname=Erdos%20Numbers" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F27%2Ferdos-numbers%2F&linkname=Erdos%20Numbers" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F27%2Ferdos-numbers%2F&linkname=Erdos%20Numbers" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>