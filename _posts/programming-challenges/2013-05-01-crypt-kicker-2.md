---
title: Crypt Kicker
date: 2013-05-01T12:53:05+08:00
pc-id: 110204
uva-id: 843
---
分析：使用回溯法求解。为了提高搜索效率，在选择“分支”时应该挑选“分支因子”较小的子树优先搜索，下面的order函数即为此目的而设。它根据单词所含字母在全句中出现的频度以及单词的长度给单词打分，然后根据分值对单词进行排序（升序），排在最后的单词会被首先破译，接下来是排在倒数第二的单词，依次进行。如果不使用order函数对加密后的单词进行排序就直接尝试破译也是可以的，不影响程序的正确性，只是会降低时间效率（虽然在本题中，仍不会超时）。<!--more-->

```cpp
#include <iostream>
#include <sstream>
#include <vector>
#include <map>
#include <string>
#include <algorithm>

#ifdef DEBUG
  #include "../comm_headers/debug_helper.h"
#else
  #define DEBUG_OUT(...) ((void)0)
#endif

using namespace std;

typedef vector<vector<string> > Dict;

class WordComparer {
public:
  WordComparer(const map<string, int> & score) : m_score(score) {}
  bool operator() (const string & a, const string & b) {
    return m_score.at(a) < m_score.at(b); //Because operator [] has no const counterpart so we have to use at() here.
  }
private:
  const map<string, int> & m_score;
};

vector<string> & order(vector<string> & enc) {
  vector<int> alphabet(26, 0);
  for (int i = 0; i < enc.size(); i++) {
    for (int j = 0; j < enc[i].size(); j++) {
      alphabet[enc[i][j] - 'a']++;
    }
  }
  map<string, int> score;
  for (int i = 0; i < enc.size(); i++) {
    int s = 0;
    for (int j = 0; j < enc[i].size(); j++) {
      s += alphabet[enc[i][j] - 'a'];
    }
    score[enc[i]] = s;
  }
  WordComparer cmp(score);
  sort(enc.begin(), enc.end(), cmp);
  return enc;
}

bool guess(const string & w, const string & dw, vector<char> & alphabet) {
  for (int i = 0; i < w.size(); i++) {
    int idx = w[i] - 'a';
    if (alphabet[idx]) {
      if (alphabet[idx] != dw[i]) {
        return false;
      }
    }
    else {
      alphabet[idx] = dw[i];
    }
  }
  vector<bool> map(alphabet.size(), false);
  for (int i = 0; i < alphabet.size(); i++) {
    if (alphabet[i]) {
      int idx = alphabet[i] - 'a';
      if (!map[idx])
        map[idx] = true;
      else
        return false;
    }
  }
  return true;
}

bool decrypt(const Dict & dict, vector<string> & enc, vector<char> & alphabet, int level = 0) {
  if (enc.empty())
    return true;

  string w = enc.back();
  DEBUG_OUT("%*sSELECT %sn", level * 2, level ? " " : "", w.c_str());

  const vector<string> & cand = dict[w.size()];
  for (int i = 0; i < cand.size(); i++) {
    vector<char> new_alphabet = alphabet;
    if (guess(w, cand[i], new_alphabet)) {
      DEBUG_OUT("%*sTRY %sn", level * 2, level ? " " : "", cand[i].c_str());
      enc.pop_back();
      if (!decrypt(dict, enc, new_alphabet, level + 1)) {
        enc.push_back(w);
      }
      else {
        alphabet = new_alphabet;
        return true;
      }
    }
  }
  return false;
}

string translate(const string & line, const vector<char> & alphabet) {
  string r(line);
  for (int i = 0; i < r.size(); i++) {
    if (r[i] != ' ')
      r[i] = alphabet[r[i] - 'a'];
  }
  return r;
}

string asterisk(const string & line) {
  string r(line);
  for (int i = 0; i < r.size(); i++) {
    if (r[i] != ' ')
      r[i] = '*';
  }
  return r;
}

int main() {
  int n;
  cin >> n;
  Dict dict(17);
  for (int i = 0; i < n; i++) {
    string word;
    cin >> word;
    dict[word.size()].push_back(word);
  }
  string line;
  getline(cin, line); //skip 'n' just after the last word
  while (getline(cin, line)) {
    if (line.size() == 0)
      break;
    istringstream is(line);
    vector<string> enc;
    string word;
    while (is >> word) {
      enc.push_back(word);
    }
    vector<char> alphabet(26);
    if (decrypt(dict, order(enc), alphabet))
      cout << translate(line, alphabet) << endl;
    else
      cout << asterisk(line) << endl;
  }
  return 0;
}
```

测试<a href="https://code.google.com/p/programming-challenges-robert/source/browse/ch2_ex4_input" target="_blank">输入</a>、<a href="https://code.google.com/p/programming-challenges-robert/source/browse/ch2_ex4_output" target="_blank">输出</a>文件

