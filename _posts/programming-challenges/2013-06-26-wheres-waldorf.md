---
title: Where’s Waldorf?
date: 2013-06-26T12:33:46+08:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110302/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=951" target="_blank">10010</a>

分析：按从上到下、从左到右的顺序对矩阵中每一个字符向八个方向查找是否存在一个以它开头的单词。<!--more-->

```cpp
#include <iostream>
#include <vector>
#include <utility>
#include <string>
#include <cctype>

using namespace std;

inline void to_lower(vector<string> & lines) {
  for (int i = 0; i < lines.size(); i++) {
    string & s = lines[i];
    for (int j = 0; j < s.size(); j++) {
      s[j] = tolower(s[j]);
    }
  }
}

inline bool find(const vector<string> & matrix, int m, int n, int i, int j,
  const string & word)
{
  int l = word.size();
  //find right
  int l_right = n - j;
  if (l <= l_right) {
    int k = j + 1, d = 1;
    for (; d < l; k++, d++) {
      if (matrix[i][k] != word[d])
        break;
    }
    if (d == l)
      return true;
  }
  //find left
  int l_left = j + 1;
  if (l <= l_left) {
    int k = j - 1, d = 1;
    for (; d < l; k--, d++) {
      if (matrix[i][k] != word[d])
        break;
    }
    if (d == l)
      return true;
  }
  //find down
  int l_down = m - i;
  if (l <= l_down) {
    int k = i + 1, d = 1;
    for (; d < l; k++, d++) {
      if (matrix[k][j] != word[d])
        break;
    }
    if (d == l)
      return true;
  }
  //find up
  int l_up = i + 1;
  if (l <= l_up) {
    int k = i - 1, d = 1;
    for (; d < l; k--, d++) {
      if (matrix[k][j] != word[d])
        break;
    }
    if (d == l)
      return true;
  }
  //find right down
  int l_right_down = l_right <= l_down ? l_right : l_down;
  if (l <= l_right_down) {
    int k = i + 1, h = j + 1, d = 1;
    for (; d < l; k++, h++, d++) {
      if (matrix[k][h] != word[d])
        break;
    }
    if (d == l)
      return true;
  }
  //find right up
  int l_right_up = l_right <= l_up ? l_right : l_up;
  if (l <= l_right_up) {
    int k = i - 1, h = j + 1, d = 1;
    for (; d < l; k--, h++, d++) {
      if (matrix[k][h] != word[d])
        break;
    }
    if (d == l)
      return true;
  }
  //find left down
  int l_left_down = l_left <= l_down ? l_left : l_down;
  if (l <= l_left_down) {
    int k = i + 1, h = j - 1, d = 1;
    for (; d < l; k++, h--, d++) {
      if (matrix[k][h] != word[d])
        break;
    }
    if (d == l)
      return true;
  }
  //find left up
  int l_left_up = l_left <= l_up ? l_left : l_up;
  if (l <= l_left_up) {
    int k = i - 1, h = j - 1, d = 1;
    for (; d < l; k--, h--, d++) {
      if (matrix[k][h] != word[d])
        break;
    }
    if (d == l)
      return true;
  }
  return false;
}

vector<pair<int, int> > where(vector<string> & matrix, vector<string> & words) {
  to_lower(matrix);
  to_lower(words);
  int c = words.size();
  vector<pair<int, int> > pos(c);
  vector<bool> found(c);
  int m = matrix.size();
  int n = matrix[0].size();
  for (int i = 0; i < m; i++) {
    for (int j = 0; j < n; j++) {
      for (int k = 0; k < c; k++) {
        if (!found[k] && matrix[i][j] == words[k][0] && find(matrix, m, n, i, j, words[k])) {
          found[k] = true;
          pos[k] = make_pair(i, j);
        }
      }
    }
  }
  return pos;
}

int main() {
  int t = 0;
  cin >> t;
  for (int i = 0; i < t; i++) {
    int m, n;
    cin >> m >> n;
    vector<string> matrix(m);
    int j;
    for (j = 0; j < m; j++) {
      cin >> matrix[j];
    }
    int k;
    cin >> k;
    vector<string> words(k);
    for (j = 0; j < k; j++) {
      cin >> words[j];
    }
    vector<pair<int, int> > pos = where(matrix, words);
    if (i)
      cout << endl;
    for (j = 0; j < pos.size(); j++) {
      cout << pos[j].first + 1 << ' ' << pos[j].second + 1 << endl;
    }
  }
  return 0;
}
```

