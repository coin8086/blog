---
title: Minesweeper
date: 2013-04-06T15:04:26+00:00
layout: post
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110102/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=1130" target="_blank">10189</a>

<!--more-->

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;

#ifdef DEBUG
#include "../comm_headers/debug_helper.h"
#else
#define DEBUG_OUT(...)
#endif

using namespace std;

typedef vector&lt;char&gt; Row;
typedef vector&lt;Row&gt; Map;

bool load_map(Map & map) {
  map.clear();
  int n_row, n_col;
  cin &gt;&gt; n_row &gt;&gt; n_col;
  if (!(n_row && n_col && cin))
    return false;

  DEBUG_OUT("row: %d col: %dn", n_row, n_col);
  for (int i = 0; i &lt; n_row; i++) {
    Row row(n_col);
    for (int j = 0; j &lt; n_col; j++) {
      cin &gt;&gt; row[j];
    }
    map.push_back(row);
  }
  return true;
}

void put_map(Map & map, int n) {
  cout &lt;&lt; "Field #" &lt;&lt; n &lt;&lt; ":" &lt;&lt; endl;
  for (int i = 0; i &lt; map.size(); i++) {
    Row & r = map[i];
    for (int j = 0; j &lt; r.size(); j++) {
      cout &lt;&lt; r[j];
    }
    cout &lt;&lt; endl;
  }
}

inline void increase(Map & map, int row, int col, int max_row, int max_col) {
  if (row &lt; 0 || row &gt;= max_row || col &lt; 0 || col &gt;= max_col)
    return;

  char ch = map[row][col];
  if (ch != '*') {
    if (ch == '.') {
      map[row][col] = '1';
    }
    else {
      map[row][col]++;
    }
  }
}

void update_neighbors(Map & map, int row, int col) {
  int up = row - 1;
  int down = row + 1;
  int left = col - 1;
  int right = col + 1;
  int max_row = map.size();
  int max_col = map[0].size();
  increase(map, up, left, max_row, max_col);
  increase(map, up, col, max_row, max_col);
  increase(map, up, right, max_row, max_col);
  increase(map, row, left, max_row, max_col);
  increase(map, row, right, max_row, max_col);
  increase(map, down, left, max_row, max_col);
  increase(map, down, col, max_row, max_col);
  increase(map, down, right, max_row, max_col);
}

void mark(Map & map) {
  for (int i = 0; i &lt; map.size(); i++) {
    Row & r = map[i];
    for (int j = 0; j &lt; r.size(); j++) {
      if (r[j] == '*') {
        update_neighbors(map, i, j);
      }
      else if (r[j] == '.') {
        r[j] = '0';
      }
    }
  }
}

int main() {
  Map map;
  int n = 0;
  while (load_map(map)) {
    ++n;
    mark(map);
    if (n != 1)
      cout &lt;&lt; endl;
    put_map(map, n);
  }
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_1">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F06%2Fminesweeper%2F&linkname=Minesweeper" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F06%2Fminesweeper%2F&linkname=Minesweeper" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F06%2Fminesweeper%2F&linkname=Minesweeper" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F06%2Fminesweeper%2F&linkname=Minesweeper" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>