---
title: Pairsumonious Numbers
date: 2013-05-20T00:54:46+08:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - programming-challenges
---
<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=1143" target="_blank">题目描述</a>

分析：设有n个整数a1,a2,...,an，已知两两整数的和，则：
  
(a1 + a2) + ... + (a1 + an) + (a2 + a3) + ... + (a2 + an) + ... + (an-1 + an) = (n - 1)S
  
其中S即a1 + a2 + ... + an的总和。
  
现假设已知a1与其它n-1个数的和分别为s1, s2,...,s(n-1)，则：
  
s1 + s2 + ... + s(n-1) = (a1 + a2) + (a1 + a3) + ... + (a1 + an) = (n - 2)a1 + S<!--more-->


  
通过S，从上式可得a1，以及a2, a3, ..., an。但问题是哪些和是包含a1的s1,s2,...？这需要我们不断地尝试，即：从n(n-1)/2个和中选出n-1个和，计算a1...an以及两两和，然后用计算得出的两两和与给出的和相比较，如相同则正解；若尝试了所有的组合都没有成功，则无解。算法利用回溯来枚举出所有可能的组合、找出一个可能的解：

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

typedef long long llt;

class Resolver {
public:
  Resolver(int n, const vector<llt> & sums) : _n(n), _total(0), _sums(sums) {}

  bool prepare() {
    for (int i = 0; i < _sums.size(); i++) {
      _total += _sums[i];
    }
    if (_total % (_n - 1)) {
      return false;
    }
    _total /= (_n - 1);
    sort(_sums.begin(), _sums.end());
    return true;
  }

  bool operator()(const vector<int> & selected) {
    //compute each number
    vector<llt> partial;
    llt partial_total = 0;
    int i;
    for (i = 0; i < selected.size(); i++) {
      llt sum = _sums[selected[i]];
      partial.push_back(sum);
      partial_total += sum;
    }
    if ((partial_total - _total) % (_n - 2))
      return false;
    llt a = (partial_total - _total) / (_n - 2);
    _numbers.clear();
    _numbers.push_back(a);
    for (i = 0; i < partial.size(); i++) {
      _numbers.push_back(partial[i] - a);
    }
    //validate
    vector<llt> sums;
    for (i = 0; i < _numbers.size(); i++) {
      for (int j = i + 1; j < _numbers.size(); j++) {
        sums.push_back(_numbers[i] + _numbers[j]);
      }
    }
    sort(sums.begin(), sums.end());
    return sums == _sums;
  }

  void get_result(vector<llt> & r) {
    sort(_numbers.begin(), _numbers.end());
    r.swap(_numbers);
  }

private:
  int _n;
  llt _total;
  vector<llt> _sums;
  vector<llt> _numbers;
};

//typedef bool (* Success)(const vector<int> & selected);

template<typename Success>
bool combine(int total, int wanted, vector<int> & selected, Success & success)
{
  if (selected.size() == wanted) {
    return success(selected);
  }
  else {
    int idx = selected.size() ? selected.back() + 1 : 0;
    for (int i = idx; i < total; i++) {
      selected.push_back(i);
      if (combine(total, wanted, selected, success))
        return true;
      selected.pop_back();
    }
  }
  return false;
}

bool solve(int n, const vector<llt> & sums, vector<llt> & r) {
  Resolver resolver(n, sums);
  if (!resolver.prepare()) {
    return false;
  }
  vector<int> selected;
  bool ret = combine(sums.size(), n - 1, selected, resolver);
  if (ret) {
    resolver.get_result(r);
  }
  return ret;
}

int main() {
  while (true) {
    int n;
    if (!(cin >> n))
      break;
    int m = n * (n - 1) / 2;
    vector<llt> input;
    llt s;
    for (int i = 0; i < m; i++) {
      cin >> s;
      input.push_back(s);
    }
    vector<llt> r;
    if (solve(n, input, r)) {
      for (int i = 0; i < r.size(); i++) {
        if (i)
          cout << ' ';
        cout << r[i];
      }
    }
    else {
      cout << "Impossible";
    }
    cout << endl;
  }
  return 0;
}
```

