---
title: The Stern-Brocot Number System
date: 2013-06-15T21:27:54+08:00
layout: post
excerpt_separator: <!--more-->
category_sticky_post:
  - "0"
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110507/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=1018" target="_blank">10077</a>

分析：Stern-Brocot树的每个节点（包括根节点）都是由两个分数生成的，分别记其为left, right。生成规则为：
  
mid.numerator = left.numerator + right.numerator
  
mid.denominator = left.denominator + right.denominator
  
且有：
  
left < mid < right <!--more-->


  
根据规则，一边生成节点一边二分查找即可。

```cpp
#include <iostream>
#include <vector>

using namespace std;

typedef long long llt;

class Fraction {
public:
  Fraction(unsigned int a, unsigned int b) : _n(a), _d(b) {}

  Fraction(const Fraction & f) : _n(f._n), _d(f._d) {}

  Fraction & operator =(const Fraction & f) {
    _n = f._n;
    _d = f._d;
    return *this;
  }

  bool operator <(const Fraction & f) const {
    return (llt)_n * f._d - (llt)_d * f._n < 0;
  }

  bool operator !=(const Fraction & f) const {
    return !(_n == f._n && _d == f._d);
  }

  Fraction middle(const Fraction & f) const {
    return Fraction(_n + f._n, _d + f._d);
  }

private:
  unsigned int _n; //numerator
  unsigned int _d; //denominator
};

vector<char> stern_brocot_path(const Fraction & f) {
  vector<char> path;
  Fraction mid(1, 1);
  Fraction left(0, 1);
  Fraction right(1, 0);
  while (f != mid) {
    if (f < mid) {
      right = mid;
      mid = mid.middle(left);
      path.push_back('L');
    }
    else {
      left = mid;
      mid = mid.middle(right);
      path.push_back('R');
    }
  }
  return path;
}

int main() {
  unsigned int a, b;
  while ((cin >> a >> b) && !(a == 1 && b == 1)) {
    vector<char> path = stern_brocot_path(Fraction(a, b));
    for (int i = 0; i < path.size(); i++)
      cout << path[i];
    cout << endl;
  }
  return 0;
}
```

