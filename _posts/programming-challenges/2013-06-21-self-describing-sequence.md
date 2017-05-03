---
title: Self-describing Sequence
date: 2013-06-21T18:15:34+08:00
layout: post
excerpt_separator: <!--more-->
category_sticky_post:
  - "0"
tags: algorithm
categories:
  - programming-challenges
---
PC/UVa IDs: 110607/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;category=34&#038;page=show_problem&#038;problem=990" target="_blank">10049</a>

分析：由于n的值可达20亿，所以把f(n)的值记录在数组里是不现实的，因此通过递推式计算f(n)也是不现实的，何况f(n)的递推式也很难得出。假设s(n)为数列f(n)的前n项和，则由数列性质可知：<!--more-->


  
f(s(n)) = n
  
这是因为f(n)的前s(n)项依次是：
  
f(1)个1、f(2)个2、……、f(n)个n
  
最后一项是n（再往后一项就是n+1了），因此又有：
  
f(s(n-1)) = n &#8211; 1
  
即：当x在区间(s(n-1), s(n)]时，f(x) = n。可以据此来求得f(x)：我们可以把s(n)的值记录在数组里，通过比较来确定x所属的区间——s(n)所组成的数列元素数量大致在几万的数量级（这可以由sample给出的一组数据来佐证：n = 1000000000, f(n) = 438744），因此记录s(n)是可以实现的。还有一个好消息就是此题不需要高精度整数运算了！

```cpp
#include <iostream>
#include <vector>

using namespace std;

vector<int> F;
vector<int> S; //Sum of first n items from F
int k; //Pointer to item in F

inline void init() {
  F.reserve(50000);
  F.push_back(0);
  F.push_back(1);
  F.push_back(2);
  F.push_back(2);
  k = 2;
  S.push_back(0);
  S.push_back(1);
  S.push_back(3);
  S.push_back(5);
}

inline int f(int n) {
  int r;
  if (F.size() > n) {
    r = F[n];
  }
  else {
    while (S.back() < n) {
      //Add f(k) occurences of k to F, and save the sum of first n items
      int c = F[++k];
      int s = S.back();
      for (int i = 0; i < c; i++) {
        F.push_back(k);
        s += k;
        S.push_back(s);
      }
    }
    for (r = S.size() - 1; r >= 0; r--) {
      if (n > S[r - 1] && n <= S[r])
        break;
    }
  }
  return r;
}

int main() {
  init();
  int n;
  while ((cin >> n) && n > 0) {
    cout << f(n) << endl;
  }
  return 0;
}
```

