---
title: Interpreter
date: 2013-04-27T20:36:17+08:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa题号：110106/10033 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&category=29&page=show_problem&problem=974" target="_blank">题目描述</a>

分析：此题根据如何来表示一条指令，有两种解法：一种是用一个整数（3位数）来表示，另一种用一个对象（含有3个成员，分别表示指令的3个位）来表示。前者的好处是存贮方便，但需要运行时“译码”；后者的好处是不需要运行时“译码”，但有额外的开销在对象的创建和复制上。根据网站的判题结果，二者的时间效率大体相当。<!--more-->

解法一：

```cpp
#include <cstdio>
#include <cstdlib>
#include <cstring>

#ifdef DEBUG
#include "../comm_headers/debug_helper.h"
#else
#define DEBUG_OUT(...)
#endif

using namespace std;

typedef int Program[1000];

void load_program(Program & p) {
  char line[32];
  int i = 0;
  memset(p, 0, sizeof(Program));
  while (fgets(line, 8, stdin)) {
    if (line[0] == 'n')
      break;
    line[3] = 0;
    p[i++] = atoi(line);
  }
}

int run_program(Program & p) {
  int r[10];
  int i = 0;
  bool halt = false;
  int count = 0;

  memset(r, 0, sizeof(int) * 10);
  while (!halt) {
    int ins = p[i++];
    int first = ins / 100;
    int remainder = ins % 100;
    int second = remainder / 10;
    int third = remainder % 10;
    count++;

    DEBUG_OUT("[%03d]%d%d%d: ", i - 1, first, second, third);

    switch (first) {
      case 0: //0ds
        DEBUG_OUT("r%d(%d)?n", third, r[third]);
        if (r[third]) {
          i = r[second];
          DEBUG_OUT("... goto [%03d]n", i);
        }
      break;

      case 1:
        halt = true;
        DEBUG_OUT("haltn");
      break;

      case 2: //2dn
        r[second] = third;
        DEBUG_OUT("r%d=%dn", second, r[second]);
      break;

      case 3: //3dn
        r[second] = (r[second] + third) % 1000;
        DEBUG_OUT("r%d=%dn", second, r[second]);
      break;

      case 4: //4dn
        r[second] = (r[second] * third) % 1000;
        DEBUG_OUT("r%d=%dn", second, r[second]);
      break;

      case 5: //5ds
        r[second] = r[third];
        DEBUG_OUT("r%d=%dn", second, r[second]);
      break;

      case 6: //6ds
        r[second] = (r[second] + r[third]) % 1000;
        DEBUG_OUT("r%d=%dn", second, r[second]);
      break;

      case 7: //7ds
        r[second] = (r[second] * r[third]) % 1000;
        DEBUG_OUT("r%d=%dn", second, r[second]);
      break;

      case 8: //8da
        r[second] = p[r[third]];
        DEBUG_OUT("r%d=%dn", second, r[second]);
      break;

      case 9: //9sa
        p[r[third]] = r[second];
        DEBUG_OUT("a[%03d]=%03dn", r[third], r[second]);
      break;
    }
  }
  return count;
}

int main() {
  char line[32];
  int n;
  if (!fgets(line, 32, stdin))
    return false;
  n = atoi(line);
  fgets(line, 32, stdin); //skip empty line

  Program p;
  for (int i = 0; i < n; i++) {
    load_program(p);
    int count = run_program(p);
    printf("%dn", count);
    if (i != n - 1)
      printf("n");
  }
  return 0;
}
```

解法二：

```cpp
#include <iostream>
#include <vector>
#include <string>

#ifdef DEBUG
#include "../comm_headers/debug_helper.h"
#else
#define DEBUG_OUT(...)
#endif

using namespace std;

class Instruction {
public:
  char first;
  char second;
  char third;
  Instruction() : first(0), second(0), third(0) {}
  Instruction(char ch1, char ch2, char ch3) : first(ch1 - '0'), second(ch2 - '0'), third(ch3 - '0') {}

  static int to_int(const Instruction & ins) {
    return ins.third + ins.second * 10 + ins.first * 100;
  }

  static Instruction from_int(int i) {
    Instruction ins;
    if (i) {
      if (i < 100) {
        ins.first = 0;
        ins.second = i / 10;
        ins.third = i % 10;
      }
      else {
        ins.first = i / 100;
        int r = i % 100;
        ins.second = r / 10;
        ins.third = r % 10;
      }
    }
    return ins;
  }
};

typedef vector<Instruction> Program;

void load_program(Program & p) {
  string line;
  p.clear();
  while (getline(cin, line)) {
    if (line.size() == 0)
      break;
    p.push_back(Instruction(line[0], line[1], line[2]));
  }
  p.resize(1000);
}

inline void overflow(int & n) {
  if (n >= 1000)
    n %= 1000;
}

int run_program(Program & p) {
  vector<int> r(10, 0);
  int i = 0;
  bool halt = false;
  int count = 0;

  while (!halt) {
    Instruction & ins = p[i++];
    count++;

    DEBUG_OUT("[%03d]%d%d%d: ", i - 1, ins.first, ins.second, ins.third);

    switch (ins.first) {
      case 0: //0ds
        DEBUG_OUT("r%d(%d)?n", ins.third, r[ins.third]);
        if (r[ins.third]) {
          i = r[ins.second];
          DEBUG_OUT("... goto [%03d]n", i);
        }
      break;

      case 1:
        halt = true;
        DEBUG_OUT("haltn");
      break;

      case 2: //2dn
        r[ins.second] = ins.third;
        DEBUG_OUT("r%d=%dn", ins.second, r[ins.second]);
      break;

      case 3: //3dn
        r[ins.second] += ins.third;
        overflow(r[ins.second]);
        DEBUG_OUT("r%d=%dn", ins.second, r[ins.second]);
      break;

      case 4: //4dn
        r[ins.second] *= ins.third;
        overflow(r[ins.second]);
        DEBUG_OUT("r%d=%dn", ins.second, r[ins.second]);
      break;

      case 5: //5ds
        r[ins.second] = r[ins.third];
        DEBUG_OUT("r%d=%dn", ins.second, r[ins.second]);
      break;

      case 6: //6ds
        r[ins.second] += r[ins.third];
        overflow(r[ins.second]);
        DEBUG_OUT("r%d=%dn", ins.second, r[ins.second]);
      break;

      case 7: //7ds
        r[ins.second] *= r[ins.third];
        overflow(r[ins.second]);
        DEBUG_OUT("r%d=%dn", ins.second, r[ins.second]);
      break;

      case 8: //8da
        r[ins.second] = Instruction::to_int(p[r[ins.third]]);
        DEBUG_OUT("r%d=%dn", ins.second, r[ins.second]);
      break;

      case 9: { //9sa
        p[r[ins.third]] = Instruction::from_int(r[ins.second]);
#ifdef DEBUG
        Instruction & ti = p[r[ins.third]];
        DEBUG_OUT("a[%03d]=%d%d%d(%03d)n", r[ins.third], ti.first, ti.second, ti.third, r[ins.second]);
#endif
      }
      break;
    }
  }
  return count;
}

int main() {
  int n;
  if (!(cin >> n))
    return false;

  //skip empty line
  string line;
  getline(cin, line);
  getline(cin, line);

  Program p;
  for (int i = 0; i < n; i++) {
    load_program(p);
    int count = run_program(p);
    cout << count << endl;
    if (i != n - 1)
      cout << endl;
  }
  return 0;
}
```

