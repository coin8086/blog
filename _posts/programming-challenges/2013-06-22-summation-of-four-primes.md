---
title: Summation of Four Primes
date: 2013-06-22T20:55:26+08:00
layout: post
excerpt_separator: <!--more-->
category_sticky_post:
  - "0"
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110705/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=1109" target="_blank">10168</a>

分析：试验表明：任何一个不小于8的整数都可以表示为四素数之和，且答案可能不唯一；另外，如果按照“从大到小”的顺序来找四个素数会比较快地找到解。因此有如下解：先用筛选质数法列出10000000以内的素数，然后用回溯法把一个整数n分解为四素数之和——在回溯时从不超过n的最大素数开始向前尝试。<!--more-->

```cpp
#include <iostream>
#include <vector>

#define MAX_N 10000000

using namespace std;

vector<int> primes;

void init() {
  vector<bool> removed(MAX_N + 1);
  primes.reserve(665000); //There are 664579 prime numbers within 10000000
  primes.push_back(2);
  int i = 3;
  for (; i <= MAX_N; i += 2) {
    if (!removed[i]) {
      primes.push_back(i);
      int s = i + i;
      for (; s <= MAX_N; s += i) {
        removed[s] = true;
      }
    }
  }
}

//The index of a prime p in primes array that is the biggest prime not bigger than n.
int index_of_prime(int n) {
  int r = -1;
  int i = 0;
  int j = primes.size();
  while (i != j) {
    int mid = (i + j) / 2;
    if (primes[mid] == n) {
      r = mid;
      break;
    }
    else if (primes[mid] > n) {
      j = mid;
      if (i == j) {
        r = mid - 1;
      }
    }
    else {
      i = mid + 1;
      if (i == j) {
        r = mid;
      }
    }
  }
  return r;
}

inline bool is_prime(int n) {
  return n < 2 ? false : primes[index_of_prime(n)] == n;
}

bool backtrack(int n, int q, vector<int> & a) {
  int r = false;
  if (q == 1) {
    if (is_prime(n)) {
      a.push_back(n);
      r = true;
    }
  }
  else {
    int i = index_of_prime(n);
    q--;
    for (; i >= 0; i--) {
      if (backtrack(n - primes[i], q, a)) {
        a.push_back(primes[i]);
        r = true;
        break;
      }
    }
  }
  return r;
}

inline bool four_primes(int n, vector<int> & a) {
  if (n < 8)
    return false;
  return backtrack(n, 4, a);
}

int main() {
  init();
  int n;
  while (cin >> n) {
    vector<int> a;
    if (four_primes(n, a)) {
      for (int i = 0; i < 4; i++) {
        if (i)
          cout << ' ';
        cout << a[i];
      }
      cout << endl;
    }
    else {
      cout << "Impossible." << endl;
    }
  }
  return 0;
}
```

需要说明的是：Programming Challenge网站表示此题尚无法正确判定答案，而UVa判以上解WA。但笔者对8到10000000的每一个整数都做了测试，结果表明笔者的解法是正确无误的。测试程序在<a href="https://code.google.com/p/programming-challenges-robert/source/browse/ch7_ex5_test.rb" target="_blank">这里</a>。

