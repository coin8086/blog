---
id: 461
title: Check the Check
date: 2013-04-14T17:12:11+00:00
author: Robert
layout: post
guid: http://kuangtong.net/?p=73
permalink: /2013/04/14/check-the-check/
categories:
  - 编程挑战
---
PC/UVa 题号：110107/10196 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&category=29&page=show_problem&problem=1137" target="_blank">题目描述</a>

分析：不需要一般象棋程序的“着法生成器”也可以求解<!--more-->

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;

using namespace std;

typedef char Board[8][8];
typedef struct _Position {
  int row;
  int col;
} Position;

bool load_board(Board & board, Position & k, Position & K) {
  bool empty = true;
  for (int i = 0; i &lt; 8; i++) {
    for (int j = 0; j &lt; 8; j++) {
      char ch;
      if (!(cin &gt;&gt; ch))
        break;

      if (empty && ch != '.')
        empty = false;

      board[i][j] = ch;

      if (ch == 'k') {
        k.row = i;
        k.col = j;
      }
      else if (ch == 'K') {
        K.row = i;
        K.col = j;
      }
    }
  }
  return !empty;
}

bool check_black(const Board & board, const Position & k) {
  //horizontal check
  for (int i = k.col + 1; i &lt; 8; i++) {
    char ch = board[k.row][i];
    if (ch == '.')
      continue;
    if (ch == 'R' || ch == 'Q')
      return true;
    break;
  }

  for (int i = k.col - 1; i &gt;= 0; i--) {
    char ch = board[k.row][i];
    if (ch == '.')
      continue;
    if (ch == 'R' || ch == 'Q')
      return true;
    break;
  }

  //vertical check
  for (int i = k.row - 1; i &gt;= 0; i--) {
    char ch = board[i][k.col];
    if (ch == '.')
      continue;
    if (ch == 'R' || ch == 'Q')
      return true;
    break;
  }

  for (int i = k.row + 1; i &lt; 8; i++) {
    char ch = board[i][k.col];
    if (ch == '.')
      continue;
    if (ch == 'R' || ch == 'Q')
      return true;
    break;
  }

  //diagonal check
  for (int i = k.row + 1, j = k.col + 1; i &lt; 8 && j &lt; 8; i++, j++) {
    char ch = board[i][j];
    if (ch == '.')
      continue;
    if (ch == 'B' || ch == 'Q' || (ch == 'P' && i == k.row + 1))
      return true;
    break;
  }

  for (int i = k.row + 1, j = k.col - 1; i &lt; 8 && j &gt;= 0; i++, j--) {
    char ch = board[i][j];
    if (ch == '.')
      continue;
    if (ch == 'B' || ch == 'Q' || (ch == 'P' && i == k.row + 1))
      return true;
    break;
  }

  for (int i = k.row - 1, j = k.col - 1; i &gt;= 0 && j &gt;= 0; i--, j--) {
    char ch = board[i][j];
    if (ch == '.')
      continue;
    if (ch == 'B' || ch == 'Q')
      return true;
    break;
  }

  for (int i = k.row - 1, j = k.col + 1; i &gt;= 0 && j &lt; 8; i--, j++) {
    char ch = board[i][j];
    if (ch == '.')
      continue;
    if (ch == 'B' || ch == 'Q')
      return true;
    break;
  }

  //knight check
  Position pos[8];
  pos[0].row = k.row + 1;
  pos[0].col = k.col + 2;

  pos[1].row = k.row + 2;
  pos[1].col = k.col + 1;

  pos[2].row = k.row + 2;
  pos[2].col = k.col - 1;

  pos[3].row = k.row + 1;
  pos[3].col = k.col - 2;

  pos[4].row = k.row - 1;
  pos[4].col = k.col - 2;

  pos[5].row = k.row - 2;
  pos[5].col = k.col - 1;

  pos[6].row = k.row - 2;
  pos[6].col = k.col + 1;

  pos[7].row = k.row - 1;
  pos[7].col = k.col + 2;

  for (int i = 0; i &lt; 8; i++) {
    Position & p = pos[i];
    if (p.row &lt; 8 && p.row &gt;= 0 && p.col &lt; 8 && p.col &gt;= 0
      && board[p.row][p.col] == 'N')
      return true;
  }

  return false;
}

inline char flip_char(char ch) {
  if (ch == '.')
    return ch;
  return ch &gt;= 'a' ? (ch - ('a' - 'A')) : (ch + ('a' - 'A'));
}

void flip_board(Board & board, Position & K) {
  for (int i = 0; i &lt; 8; i++) {
    for (int j = 0; j &lt; 4; j++) {
      char up = board[j][i];
      char down = board[7 - j][i];
      board[j][i] = flip_char(down);
      board[7 - j][i] = flip_char(up);
    }
  }
  K.row = 7 - K.row;
}

int check_board(Board & board, Position & k, Position & K) {
  if (check_black(board, k))
    return 1;
  flip_board(board, K);
  return check_black(board, K) ? 2 : 0;
}

int main() {
  Board board;
  Position k, K;
  int d = 0;
  while (load_board(board, k, K)) {
    int r = check_board(board, k, K);
    const char * who;
    switch (r) {
      case 0:
        who = "no king";
      break;
      case 1:
        who = "black king";
      break;
      case 2:
        who = "white king";
      break;
    }
    cout &lt;&lt; "Game #" &lt;&lt; ++d &lt;&lt; ": " &lt;&lt; who &lt;&lt; " is in check." &lt;&lt; endl;
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_4">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F14%2Fcheck-the-check%2F&linkname=Check%20the%20Check" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F14%2Fcheck-the-check%2F&linkname=Check%20the%20Check" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F14%2Fcheck-the-check%2F&linkname=Check%20the%20Check" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F14%2Fcheck-the-check%2F&linkname=Check%20the%20Check" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>