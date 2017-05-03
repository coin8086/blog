---
title: Poker Hands
date: 2013-04-21T21:16:38+00:00
layout: post
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa 题号：110202/10315 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&category=30&page=show_problem&problem=1256" target="_blank">题目描述</a><!--more-->

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;cassert&gt;
#include &lt;iostream&gt;
#include &lt;vector&gt;

using namespace std;

class Card {
public:
  char v;
  char t;
  Card(char av, char at) : v(av), t(at) {}
  Card() : v(0), t(0) {}
};

typedef enum {
  Unknown = 0,
  Big = 1,
  Pair,
  TwoPairs,
  Three,
  Sequence,
  SameColor,
  ThreeWithPair,
  Four,
  SequenceWithSameColor
} CardType;

typedef vector&lt;vector&lt;char&gt; &gt; TypeInfo;

#define VALUES "23456789TJQKA"

#ifdef DEBUG
  #include "../comm_headers/debug_helper.h"

  void SHOW_CARDS(const vector&lt;Card&gt; & cards) {
    for (int i = 0; i &lt; cards.size(); i++) {
      DEBUG_OUT("%c%c ", VALUES[cards[i].v], cards[i].t);
    }
    DEBUG_OUT("n");
  }

  const char * TYPE_NAMES[] = {
    "Unknown",
    "Big",
    "Pair",
    "TwoPairs",
    "Three",
    "Sequence",
    "SameColor",
    "ThreeWithPair",
    "Four",
    "SequenceWithSameColor"
  };

  void SHOW_TYPE_INFO(CardType t, const TypeInfo & ti) {
    DEBUG_OUT("type: %sn", TYPE_NAMES[t]);
    for (int i = 1; i &lt; ti.size(); i++) {
      DEBUG_OUT("%d: [", i);
      for (int j = 0; j &lt; ti[i].size(); j++) {
        DEBUG_OUT("%c, ", VALUES[ti[i][j]]);
      }
      DEBUG_OUT("]n");
    }
  }

#else
  #define DEBUG_OUT(...) ((void)0)
  #define SHOW_CARDS(x) ((void)0)
  #define SHOW_TYPE_INFO(x, y) ((void)0)
#endif

inline char value(char v) {
  for (int i = 0; i &lt; 13; i++) {
    if (VALUES[i] == v)
      return i;
  }
  assert(0 && "invalid value!");
  return -1;
}

bool load_cards(vector&lt;Card&gt; & cards) {
  cards.clear();
  cards.resize(5);
  for (int i = 0; i &lt; 5; i++) {
    char v, t;
    if (!(cin &gt;&gt; v &gt;&gt; t))
      return false;
    v = value(v);
    Card c(v, t);
    int j = i - 1;
    for (; j &gt;= 0; j--) {
      if (cards[j].v &lt; v)
        cards[j + 1] = cards[j];
      else
        break;
    }
    cards[j + 1] = c;
  }
  SHOW_CARDS(cards);
  return true;
}

bool load_input(vector&lt;Card&gt; & b, vector&lt;Card&gt; & w) {
  return load_cards(b) && load_cards(w);
}

CardType type(const vector&lt;Card&gt; & cards, TypeInfo & info) {
  assert(5 == cards.size());
  bool same_color = true;
  char c = cards[0].t;
  int i;
  for (i = 1; i &lt; 5; i++) {
    if (cards[i].t != c) {
      same_color = false;
      break;
    }
  }

  bool sequential = true;
  for (i = 0; i &lt; 4; i++) {
    if (cards[i].v - cards[i + 1].v != 1) {
      sequential = false;
      break;
    }
  }

  if (same_color && sequential)
    return SequenceWithSameColor;

  if (sequential)
    return Sequence;

  if (same_color)
    return SameColor;

  info.resize(5);

  int n_pair = 0, n_three = 0, n_four = 0;
  char v = cards[0].v;
  int len = 1;
  for (i = 1; i &lt;= 5; i++) {
    if (i != 5 && cards[i].v == v) {
      len++;
    }
    else {
      switch (len) {
        case 2:
          n_pair++;
          info[2].push_back(v);
          break;
        case 3:
          n_three++;
          info[3].push_back(v);
          break;
        case 4:
          n_four++;
          info[4].push_back(v);
          break;
      }
      if (i != 5) {
        v = cards[i].v;
        len = 1;
      }
    }
  }

  if (n_four)
    return Four;

  if (n_three)
    return n_pair ? ThreeWithPair : Three;

  if (n_pair) {
    vector&lt;char&gt; & excludes = info[2];
    for (i = 0; i &lt; 5; i++) {
      char v = cards[i].v;
      bool excluded = false;
      for (int j = 0; j &lt; excludes.size(); j++) {
        if (v == excludes[j]) {
          excluded = true;
          break;
        }
      }
      if (!excluded)
        info[1].push_back(v);
    }
    return n_pair == 2 ? TwoPairs : Pair;
  }

  return Big;
}

int compare_sequence(const vector&lt;Card&gt; & b, const vector&lt;Card&gt; & w) {
  assert(b.size() == w.size());
  for (int i = 0; i &lt; b.size(); i++) {
    char r = b[i].v - w[i].v;
    if (r) {
      return r;
    }
  }
  return 0;
}

int compare(const vector&lt;Card&gt; & b, const vector&lt;Card&gt; & w) {
  TypeInfo tib, tiw;
  CardType tb = type(b, tib);
  CardType tw = type(w, tiw);
  SHOW_TYPE_INFO(tb, tib);
  SHOW_TYPE_INFO(tw, tiw);
  int r = tb - tw;
  if (!r) {
    switch (tb) {
      case Big: {
        r = compare_sequence(b, w);
        break;
      }
      case Pair: {
        r = tib[2][0] - tiw[2][0];
        if (!r) {
          for (int i = 0; i &lt; tib[1].size(); i++) {
            r = tib[1][i] - tiw[1][i];
            if (r)
              break;
          }
        }
        break;
      }
      case TwoPairs: {
        r = (tib[2][0] - tiw[2][0]);
        if (!r)
          r = (tib[2][1] - tiw[2][1]);
        if (!r)
          r = (tib[1][0] - tiw[1][0]);
        break;
      }
      case Three: {
        r = tib[3][0] - tiw[3][0];
        break;
      }
      case Sequence: {
        r = b[0].v - w[0].v;
        break;
      }
      case SameColor: {
        r = compare_sequence(b, w);
        break;
      }
      case ThreeWithPair: {
        r = tib[3][0] - tiw[3][0];
        break;
      }
      case Four: {
        r = tib[4][0] - tiw[4][0];
        break;
      }
      case SequenceWithSameColor: {
        r = b[0].v - w[0].v;
        break;
      }
    }
  }
  return r;
}

int main() {
  vector&lt;Card&gt; b, w;
  while (load_input(b, w)) {
    int r = compare(b, w);
    if (r &gt; 0)
      cout &lt;&lt; "Black wins.";
    else if (r &lt; 0)
      cout &lt;&lt; "White wins.";
    else
      cout &lt;&lt; "Tie.";
    cout &lt;&lt; endl;
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_6">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F21%2Fpoker-hands%2F&linkname=Poker%20Hands" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F21%2Fpoker-hands%2F&linkname=Poker%20Hands" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F21%2Fpoker-hands%2F&linkname=Poker%20Hands" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F21%2Fpoker-hands%2F&linkname=Poker%20Hands" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>