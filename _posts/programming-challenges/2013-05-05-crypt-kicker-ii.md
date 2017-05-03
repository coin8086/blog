---
title: Crypt Kicker II
date: 2013-05-05T10:57:11+00:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa题号：110304/850 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&page=show_problem&problem=791" target="_blank">题目描述</a>

分析：注意到“the quick brown fox jumps over the lazy dog”包含了全部26个英文字母，所以只要找到一句相匹配的密文，就可以解密全部了。<!--more-->

```cpp
#include &lt;iostream&gt;
#include &lt;sstream&gt;
#include &lt;string&gt;
#include &lt;vector&gt;
#include &lt;cstdlib&gt;

using namespace std;

typedef vector&lt;string&gt; Line;

string known_line = "the quick brown fox jumps over the lazy dog";
Line known;

inline Line break_down(const string & line) {
  Line words;
  string word;
  istringstream is(line);
  while (is &gt;&gt; word) {
    words.push_back(word);
  }
  return words;
}

inline void init() {
  known = break_down(known_line);
}

bool match_word(const string & enc, const string & known, vector&lt;char&gt; & alphabet) {
  if (enc.size() != known.size())
    return false;
  vector&lt;char&gt; alpha = alphabet;
  for (int i = 0; i &lt; enc.size(); i++) {
    int idx = enc[i] - 'a';
    if (alpha[idx]) {
      if (alpha[idx] != known[i]) {
        return false;
      }
    }
    else {
      alpha[idx] = known[i];
    }
  }
  vector&lt;bool&gt; map(alpha.size(), false);
  for (int i = 0; i &lt; alpha.size(); i++) {
    if (alpha[i]) {
      int idx = alpha[i] - 'a';
      if (!map[idx])
        map[idx] = true;
      else
        return false;
    }
  }
  alphabet = alpha;
  return true;
}

bool match_line(const Line & encrypted, vector&lt;char&gt; & alphabet) {
  if (encrypted.size() != known.size())
    return false;
  vector&lt;char&gt; alpha(26);
  for (int i = 0; i &lt; encrypted.size(); i++) {
    if (!match_word(encrypted[i], known[i], alpha))
      return false;
  }
  alphabet = alpha;
  return true;
}

inline bool decrypt(const vector&lt;string&gt; & lines, vector&lt;char&gt; & alphabet) {
  for (int i = 0; i &lt; lines.size(); i++) {
    if (match_line(break_down(lines[i]), alphabet))
      return true;
  }
  return false;
}

inline string translate(const string & line, const vector&lt;char&gt; & alphabet) {
  string r(line);
  for (int i = 0; i &lt; r.size(); i++) {
    if (r[i] != ' ')
      r[i] = alphabet[r[i] - 'a'];
  }
  return r;
}

int main() {
  init();
  string line;
  getline(cin, line);
  int n_test = atoi(line.c_str());
  getline(cin, line); //skip empty line
  for (int i = 0; i &lt; n_test; i++) {
    vector&lt;string&gt; lines;
    while (getline(cin, line) && !line.empty()) {
      lines.push_back(line);
    }
    vector&lt;char&gt; alphabet(26);
    if (decrypt(lines, alphabet)) {
      for (int j = 0; j &lt; lines.size(); j++) {
        cout &lt;&lt; translate(lines[j], alphabet) &lt;&lt; endl;
      }
    }
    else {
      cout &lt;&lt; "No solution." &lt;&lt; endl;
    }
    if (i != n_test - 1)
      cout &lt;&lt; endl;
  }
}
```

