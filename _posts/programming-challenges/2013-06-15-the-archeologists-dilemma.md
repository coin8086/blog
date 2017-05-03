---
title: The Archeologist’s Dilemma
date: 2013-06-15T11:35:17+00:00
layout: post
excerpt_separator: <!--more-->
category_sticky_post:
  - "0"
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110503/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=642" target="_blank">701</a>

分析：5.4节《进制及其转换》提到：把一个a进制整数x转化成b进制整数y的“自左向右”方法是：首先求出y的最高位dl
  
(dl + 1) \* b ^ k > x >= dl \* b ^ k
  
在本题中令x = 2 ^ e，已知十进制y的高n位，则有：
  
(dl + 1) \* 10 ^ k > 2 ^ e > dl \* 10 ^ k
  
其中<!--more-->


  
k + 1 > 2n
  
因为要满足“已知的位数n严格少于丢失的位数”。我们可以从k = 2n开始尝试求以上不等式的整数解e，但e仍需满足：
  
(d(l &#8211; 1) + 1) \* 10 ^ (k &#8211; 1) > (2 ^ e &#8211; dl \* 10 ^ k) >= d(l &#8211; 1) * 10 ^ (k &#8211; 1)
  
及d(l &#8211; 2)&#8230;直到d(1)的一系列不等式。所有n位都满足的整数e即正解。但还有一个问题：什么时候不存在解？笔者无法证明解始终存在，有线索的读者或可给出。
  
另外，还有一个比较简单的实现方法：根据公式
  
N * 10 ^ k < 2 ^ e < (N + 1) * 10 ^ k
  
其中N为已知的10进制数（即y的高n位），可以实现比较简单的验算，<a href="http://blog.csdn.net/metaphysis/article/details/6453199" target="_blank">例如这样</a>；但根据UVa的测试结果，笔者的实现大概比后者快40%左右。

```cpp
#include <iostream>
#include <vector>
#include <cmath>

#define MAX_SIZE 10

long double LOG2 = log(2);
long double LOG2_10 = log(10) / LOG2;

using namespace std;

inline vector<char> to_vec(unsigned int n) {
  vector<char> v;
  v.reserve(MAX_SIZE);
  while (n) {
    v.push_back(n % 10);
    n /= 10;
  }
  return v;
}

unsigned int power_of_2(unsigned int n) {
  unsigned int e = 0;
  vector<char> v = to_vec(n);
  int dl = v.back();    //The highest digit.
  int k = 2 * v.size(); //dl * 10 ^ k
  long double log2_dl = log(dl) / LOG2;
  long double log2_dl_plus = log(dl + 1) / LOG2;
  long double k_log2_10 = k * LOG2_10;
  while (true) {
    //(dl + 1) * 10 ^ k > 2 ^ e >= dl * 10 ^ k
    e = ceil(log2_dl + k_log2_10);
    if (e < log2_dl_plus + k_log2_10) {
      //The next digit, dm, if it exists, must satisfy
      //(dm + 1) * 10 ^ (k - 1) > (2 ^ e - (dl * 10 ^ k)) >= dm * 10 ^ (k - 1)
      //And the next next digit repeats this pattern.
      unsigned int s = dl;
      long double m_log2_10 = k_log2_10;
      int i = v.size() - 2;
      for (; i >= 0; i--) {
        s *= 10;
        s += v[i];
        m_log2_10 -= LOG2_10;
        if (e < log(s) / LOG2 + m_log2_10 || e >= log(s + 1) / LOG2 + m_log2_10)
          break;
      }
      if (i < 0)
        break;
    }
    k_log2_10 += LOG2_10;
  }
  return e;
}

int main() {
  unsigned int n;
  while (cin >> n) {
    cout << power_of_2(n) << endl;
  }
  return 0;
}
```

