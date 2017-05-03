---
title: LC-Display
date: 2013-04-07T18:07:04+00:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa 题号：110104/706 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&category=29&page=show_problem&problem=647" target="_blank">题目描述</a><!--more-->

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;algorithm&gt;

#ifdef DEBUG
#include "../comm_headers/debug_helper.h"
#else
#define DEBUG_OUT(...)
#endif

using namespace std;

typedef vector&lt;char&gt; Row;
typedef vector&lt;Row&gt; Matrix;
typedef vector&lt;Matrix&gt; Font;

vector&lt;Font&gt; fonts(10);

char digits[][5][3] = {
  //0
  {
    {' ', '-', ' '},
    {'|', ' ', '|'},
    {' ', ' ', ' '},
    {'|', ' ', '|'},
    {' ', '-', ' '},
  },
  //1
  {
    {' ', ' ', ' '},
    {' ', ' ', '|'},
    {' ', ' ', ' '},
    {' ', ' ', '|'},
    {' ', ' ', ' '},
  },
  //2
  {
    {' ', '-', ' '},
    {' ', ' ', '|'},
    {' ', '-', ' '},
    {'|', ' ', ' '},
    {' ', '-', ' '},
  },
  //3
  {
    {' ', '-', ' '},
    {' ', ' ', '|'},
    {' ', '-', ' '},
    {' ', ' ', '|'},
    {' ', '-', ' '},
  },
  //4
  {
    {' ', ' ', ' '},
    {'|', ' ', '|'},
    {' ', '-', ' '},
    {' ', ' ', '|'},
    {' ', ' ', ' '},
  },
  //5
  {
    {' ', '-', ' '},
    {'|', ' ', ' '},
    {' ', '-', ' '},
    {' ', ' ', '|'},
    {' ', '-', ' '},
  },
  //6
  {
    {' ', '-', ' '},
    {'|', ' ', ' '},
    {' ', '-', ' '},
    {'|', ' ', '|'},
    {' ', '-', ' '},
  },
  //7
  {
    {' ', '-', ' '},
    {' ', ' ', '|'},
    {' ', ' ', ' '},
    {' ', ' ', '|'},
    {' ', ' ', ' '},
  },
  //8
  {
    {' ', '-', ' '},
    {'|', ' ', '|'},
    {' ', '-', ' '},
    {'|', ' ', '|'},
    {' ', '-', ' '},
  },
  //9
  {
    {' ', '-', ' '},
    {'|', ' ', '|'},
    {' ', '-', ' '},
    {' ', ' ', '|'},
    {' ', '-', ' '},
  },
};

vector&lt;int&gt; number_to_digits(int n) {
  vector&lt;int&gt; r;
  if (!n) {
    r.push_back(0);
  }
  else {
    while (n) {
      r.push_back(n % 10);
      n = n / 10;
    }
    reverse(r.begin(), r.end());
  }
  return r;
}

void draw(int n, int s);

void init_fonts() {
  DEBUG_OUT("init_fonts()n");
  for (int i = 0; i &lt; fonts.size(); i++) {
    fonts[i].resize(10);
  }
  Font & s1 = fonts[0];
  for (int i = 0; i &lt; 10; i++) {
    s1[i].resize(5);
    for (int j = 0; j &lt; 5; j++) {
      s1[i][j].resize(3);
      for (int k = 0; k &lt; 3; k++) {
        s1[i][j][k] = digits[i][j][k];
        DEBUG_OUT("%c", s1[i][j][k]);
      }
      DEBUG_OUT("n");
    }
    DEBUG_OUT("n");
  }
}

const Matrix & digit_to_matrix(int d, int s) {
  Matrix & matrix = fonts[s - 1][d];
  if (matrix.size() &gt; 0)
    return matrix;

  Matrix & s1 = fonts[0][d];

  matrix.resize(2 * s + 3);
  for (int i = 0; i &lt; s * 2 + 3; i++) {
    matrix[i].resize(s + 2, ' ');
  }

  //top line
  char ch = s1[0][1];
  if (ch != ' ')
    for (int i = 1; i &lt;= s; i++)
      matrix[0][i] = ch;

  //middle line
  ch = s1[2][1];
  if (ch != ' ')
    for (int i = 1; i &lt;= s; i++)
      matrix[s + 1][i] = ch;

  //bottom line
  ch = s1[4][1];
  if (ch != ' ')
    for (int i = 1; i &lt;= s; i++)
      matrix[2 * s + 2][i] = ch;

  //left up side
  ch = s1[1][0];
  if (ch != ' ')
    for (int i = 1; i &lt;= s; i++)
      matrix[i][0] = ch;

  //left down side
  ch = s1[3][0];
  if (ch != ' ')
    for (int i = 1; i &lt;= s; i++)
      matrix[s + 1 + i][0] = ch;

  //right up side
  ch = s1[1][2];
  if (ch != ' ')
    for (int i = 1; i &lt;= s; i++)
      matrix[i][s + 1] = ch;

  //right down side
  ch = s1[3][2];
  if (ch != ' ')
    for (int i = 1; i &lt;= s; i++)
      matrix[s + 1 + i][s + 1] = ch;

  return matrix;
}

void draw(int n, int s) {
  vector&lt;int&gt; digits = number_to_digits(n);
  for (int r = 0; r &lt; 2 * s + 3; r++) {
    for (int i = 0; i &lt; digits.size(); i++) {
      if (i)
        cout &lt;&lt; ' ';

      const Matrix & m = digit_to_matrix(digits[i], s);
      for (int j = 0; j &lt; s + 2; j++) {
        cout &lt;&lt; m[r][j];
      }
    }
    cout &lt;&lt; endl;
  }
  cout &lt;&lt; endl;
}

int main() {
  init_fonts();

  int s, n;
  while (cin &gt;&gt; s &gt;&gt; n) {
    DEBUG_OUT("s: %d n: %dn", s, n);
    if (!s && !n)
      break;

    draw(n, s);
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_3">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F07%2Flc-display%2F&linkname=LC-Display" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F07%2Flc-display%2F&linkname=LC-Display" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F07%2Flc-display%2F&linkname=LC-Display" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F07%2Flc-display%2F&linkname=LC-Display" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>