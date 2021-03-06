---
title: Edit Step Ladders
date: 2013-05-31T22:18:50+08:00
pc-id: 110905
uva-id: 10029
---
分析：按字典序排列的n个单词构成了一个隐式的有向无环图：每个单词单词都有一条出边指向在它字典序之后的每一个单词。要在这张图里找出符合条件的最长路径包含的顶点数。简单的想法就是“暴力”回溯了：对每个顶点进行一次回溯，找出以该点开始的最长的edit step ladder——这个时间复杂度高得能上了火星！思考一下就会发现，回溯包含了大量的重复计算：假设以单词w开始的最长ladder长度为l，那么对于字典中排在w之前的每一个单词（实际上是edit step为1的那些单词），在回溯经过w时都要做同样的重复计算，浪费了大量时间。如果我们计算好了以w开始的最长ladder的长度l，那么对于w的每一个one edit step前驱顶点，其最长ladder长度即为l+1。<!--more-->想到这里，我们可以从字典最后一个单词开始向前，计算每一个单词的最长ladder长度并保存，如下：

（需要注意的是：虽然算法的时间复杂度是O(n^2)，但若不考虑优化系数，仍然会在UVa里超时。为此以下算法把已计算过的单词按长度分组以减少比较次数，降低时间复杂度系数）

```cpp
#include <iostream>
#include <vector>
#include <map>
#include <string>

using namespace std;

typedef vector<string> Dict;
typedef map<string, int> LadderLen;

//p1 and p2 must have the same length.
inline bool equal(const char * p1, const char * p2) {
  for (; *p1 && *p1 == *p2; p1++, p2++);
  return !*p1;
}

//w1 and w2 must be different and not empty!
bool one_step(const string & w1, const string & w2) {
  bool r = false;
  int d = w1.size() - w2.size();
  const char * p1 = w1.c_str();
  const char * p2 = w2.c_str();
  if (!d) {
    while (*p1++ == *p2++);
    if (!*p1)
      r = true;
    else
      r = equal(p1, p2);
  }
  else {
    while (*p1++ == *p2++);
    if (d > 0)
      r = equal(p1, --p2);
    else
      r = equal(p2, --p1);
  }
  return r;
}

inline void search(const string & w, const Dict & d, LadderLen & len, int & max) {
  for (int j = 0; j < d.size(); j++) {
    const string & w2 = d[j];
    if (one_step(w, w2) && len[w2] > max) {
      max = len[w2];
    }
  }
}

int ladder(const Dict & d) {
  LadderLen len;
  vector<Dict> d2(17);
  int r = 0;
  for (int i = d.size() - 1; i > 0; i--) {
    const string & w = d[i];
    int max = -1;
    search(w, d2[w.size()], len, max);
    if (w.size() < 16)
      search(w, d2[w.size() + 1], len, max);
    if (w.size() > 1)
      search(w, d2[w.size() - 1], len, max);
    d2[w.size()].push_back(w);
    len[w] = ++max;
    if (max > r)
      r = max;
  }
  return r + 1;
}

int main() {
  Dict d(1); //The first word is just a place holder
  string w;
  while (cin >> w) {
    d.push_back(w);
  }
  cout << ladder(d) << endl;
  return 0;
}
```

结语：其实，所谓的动态规划，很像回溯的逆过程：前者从“前”往后递增计算，后者从“后”往前递减计算。只不过前者还记录了一些计算的中间结果以避免重复计算（其实后者也可以，但考虑到栈的深度，一些情况下回溯并不合适）。

