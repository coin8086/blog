---
title: Erdos Numbers
date: 2013-06-27T23:13:27+00:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110206/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=985" target="_blank">10044</a>

分析：如果把一个作者看作一个顶点，若两个作者合作发表过一篇论文则对应的两点有一条边相连，那么一个作者的Erdos数就是该点到Erdos点的最短距离。在此图中从Erdos点开始宽度优先遍历即可得解。不过，此题真正困难之处并不在此，<!--more-->而在于如何处理输入！因为题目对于输入格式的说明含混不清，仅举了个例子，且例子也没包括一些特殊情况，所以大家就只能猜了！读者可以参考UVa BBS上的

<a href="http://online-judge.uva.es/board/viewtopic.php?f=9&#038;t=2931&#038;start=15&#038;hilit=Erdos+Numbers" target="_blank">相关讨论</a>，或者试试这个<a href="https://code.google.com/p/programming-challenges-robert/source/browse/ch2_ex6_input" target="_blank">input</a>，对应的<a href="https://code.google.com/p/programming-challenges-robert/source/browse/ch2_ex6_output" target="_blank">output</a>在这里——程序必须通过这样的测试才有可能AC。笔者必须说，此题对输入格式的描述极不严谨，极大地浪费了读者的时间，在这样一本书中实属不该。

```cpp
#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <set>
#include <queue>
#include <cctype>
#include <climits>

#define ERDOS "Erdos, P."

using namespace std;

typedef map<string, set<string> > Relation;

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

inline vector<string> parse_authors(const string & line) {
  vector<string> a;
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

inline void relate(Relation & r, const vector<string> & authors) {
  int n = authors.size();
  for (int i = 0; i < n; i++) {
    for (int j = i + 1; j < n; j++) {
      r[authors[i]].insert(authors[j]);
      r[authors[j]].insert(authors[i]);
    }
  }
}

vector<int> erdos_numbers(const Relation & r, const vector<string> & authors) {
  vector<int> en(authors.size(), INT_MAX);
  if (r.count(ERDOS)) { //Erdos himself may not in r at all!
    map<string, int> stat;
    queue<string> q;
    stat[ERDOS] = 0;
    q.push(ERDOS);
    while (!q.empty()) {
      string author = q.front();
      q.pop();
      int n = stat[author];
      const set<string> & coauthors = r.at(author);
      set<string>::const_iterator it = coauthors.begin();
      for (; it != coauthors.end(); it++) {
        if (!stat.count(*it)) {
          stat[*it] = n + 1;
          q.push(*it);
        }
      }
    }
    for (int i = 0; i < authors.size(); i++) {
      map<string, int>::iterator it = stat.find(authors[i]);
      if (it != stat.end())
        en[i] = it->second;
    }
  }
  return en;
}

int main() {
  int N = 0;
  cin >> N;
  for (int i = 1; i <= N; i++) {
    int p, n;
    cin >> p >> n;
    Relation r;
    string line;
    getline(cin, line); //Skip empty line
    int j;
    for (j = 0; j < p; j++) {
      getline(cin, line);
      relate(r, parse_authors(line));
    }
    vector<string> authors;
    authors.reserve(n);
    for (j = 0; j < n; j++) {
      getline(cin, line);
      authors.push_back(parse_author(line));
    }
    vector<int> en = erdos_numbers(r, authors);
    cout << "Scenario " << i << endl;
    for (j = 0; j < n; j++) {
      cout << authors[j] << ' ';
      if (en[j] == INT_MAX)
        cout << "infinity";
      else
        cout << en[j];
      cout << endl;
    }
  }
  return 0;
}
```

