---
title: Australian Voting
date: 2013-06-29T01:22:38+00:00
layout: post
categories:
  - 编程挑战
---
PC/UVa IDs: 110108/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=1083" target="_blank">10142</a>

分析：用什么样的数据结构来表示投票有很多选择；如果选择了合适的数据结构，不但可以提高时间效率还可以简化编程。<!--more-->

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;sstream&gt;
#include &lt;string&gt;
#include &lt;vector&gt;
#include &lt;map&gt;
#include &lt;algorithm&gt;

using namespace std;

typedef vector&lt;int&gt; Voting;
typedef map&lt;int, vector&lt;Voting&gt; &gt; Result;

class Candidate {
public:
  Candidate(int ai, int av) : idx(ai), votes(av) {}
  bool operator &lt;(const Candidate & c) const { return votes &gt; c.votes; }
  int idx;   //index for a candidate
  int votes; //his/her votes
};

inline Result init(const vector&lt;Voting&gt; & votings) {
  Result result;
  for (int i = 0; i &lt; votings.size(); i++) {
    result[votings[i].back()].push_back(votings[i]);
  }
  return result;
}

bool elect(const Result & result, int total, vector&lt;int&gt; & victors,
  vector&lt;int&gt; & losers)
{
  bool over = false;
  victors.clear();
  losers.clear();
  vector&lt;Candidate&gt; cand;
  Result::const_iterator it = result.begin();
  for (; it != result.end(); it++) {
    cand.push_back(Candidate(it-&gt;first, it-&gt;second.size()));
  }
  sort(cand.begin(), cand.end());
  if (cand[0].votes * 1.0 / total &gt; 0.5) {
    over = true;
    victors.push_back(cand[0].idx);
  }
  else if (cand.front().votes == cand.back().votes) {
    over = true;
    for (int i = 0; i &lt; cand.size(); i++) {
      victors.push_back(cand[i].idx);
    }
  }
  else {
    int v = cand.back().votes;
    losers.push_back(cand.back().idx);
    for (int i = cand.size() - 2; i &gt; 0; i--) {
      if (cand[i].votes == v)
        losers.push_back(cand[i].idx);
    }
  }
  return over;
}

inline bool contain(const vector&lt;int&gt; & vec, int e) {
  return find(vec.begin(), vec.end(), e) != vec.end();
}

void eliminate(Result & result, const vector&lt;int&gt; & losers) {
  for (int i = 0; i &lt; losers.size(); i++) {
    Result::iterator it = result.find(losers[i]);
    vector&lt;Voting&gt; & votings = it-&gt;second;
    //Reassign losers' votings to those non-eliminated
    for (int j = 0; j &lt; votings.size(); j++) {
      Voting & v = votings[j];
      v.pop_back();
      while (!result.count(v.back()) || contain(losers, v.back()))
        v.pop_back();
      result[v.back()].push_back(v);
    }
    result.erase(it);
  }
}

inline vector&lt;int&gt; vote(const vector&lt;Voting&gt; & votings) {
  vector&lt;int&gt; victors;
  vector&lt;int&gt; losers;
  Result result = init(votings);
  int total = votings.size();
  while (!elect(result, total, victors, losers)) {
    eliminate(result, losers);
  }
  return victors;
}

int main() {
  int N = 0;
  cin &gt;&gt; N;
  for (int i = 0; i &lt; N; i++) {
    int n;
    cin &gt;&gt; n;
    //Read candidate names
    string line;
    getline(cin, line); //Skip empty line
    vector&lt;string&gt; names(n + 1);
    int j;
    for (j = 1; j &lt;= n; j++) {
      getline(cin, names[j]);
    }
    //Read votings
    vector&lt;Voting&gt; votings;
    votings.reserve(1000);
    getline(cin, line);
    while(!line.empty()) {
      istringstream is(line);
      Voting v;
      v.reserve(n);
      for (int k = 0; k &lt; n; k++) {
        int p;
        is &gt;&gt; p;
        v.push_back(p);
      }
      //The last one has the highest rank, the first one the lowest.
      //This is for efficient removing an eliminated candidate.
      reverse(v.begin(), v.end());
      votings.push_back(v);
      getline(cin, line);
    }
    vector&lt;int&gt; victors = vote(votings);
    if (i)
      cout &lt;&lt; endl;
    for (j = 0; j &lt; victors.size(); j++) {
      cout &lt;&lt; names[victors[j]] &lt;&lt; endl;
    }
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_52">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F29%2Faustralian-voting%2F&linkname=Australian%20Voting" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F29%2Faustralian-voting%2F&linkname=Australian%20Voting" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F29%2Faustralian-voting%2F&linkname=Australian%20Voting" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F29%2Faustralian-voting%2F&linkname=Australian%20Voting" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>