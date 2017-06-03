---
title: Slash Maze
date: 2017-06-02T16:15:00+08:00
pc-id: 110904
uva-id: 705
---
这道题不简单！首先要把迷宫表示成可遍历的图，其次要找出图中所有的环及其长度。

第一个问题就很棘手：只用斜线矩阵（构成的邻接矩阵）来表示图可以吗？这种方式看似简单可行——可以遍历出环——但是难以计算环的长度（如环内部的情况比较复杂时），而且难以枚举出所有环（环和环之间可能有共享边），必须考虑其他方式。

<!--more-->

比较直观的想法是把斜线迷宫用网格表示，如图：

![](/images/slash-maze-1.jpg){:width="300px"}
![](/images/slash-maze-2.jpg){:width="300px"}

每一条斜线对应上下左右四个网格，并且：

* 斜线`\`分别联通上右、左下
* 斜线`/`分别联通上左、右下

对于某个坐标为m(h, w)的斜线，如果定义其对应的上方的网格坐标为g(i, j)，则左、右、下方网格的坐标分别为g(i + 1, j)、g(i, j + 1)、g(i + 1, j + 1)，如图：

![](/images/slash-maze-3.jpg){:width="300px"}

此外，斜线m(h, w)右边的斜线m(h, w + 1)对应的上方网格的坐标是g(i - 1, j + 1)，下边斜线m(h + 1, w)对应的上方网格的坐标是g(i + 1, j + 1)，如图：

![](/images/slash-maze-4.jpg){:width="300px"}

这样，如果设m(0, 0)对应的上方网格坐标为g(0, 0)，按行列顺序遍历迷宫的斜线矩阵，就能得到一个对应的网格图。代码如下：

```cpp
typedef pair<int, int> Point;

typedef map<Point, vector<Point> > Grid;

typedef vector<vector<char> > Maze;

Grid mazeToGrid(const Maze & m) {
  Grid g;
  int i = 0, j = 0; //Grid coordinates
  int x, y;         //Maze coordinates
  int h = m.size();
  int w = m[0].size();
  //Initially, let m(0, 0) corresponds to g(0, 0). This may cause negative i/j
  //for a grid, but it doesn't matter, since grid g is a adjacency list.
  for (x = 0; x < h; x++) {
    int oi = i;
    int oj = j;
    for (y = 0; y < w; y++) {
      //m(x, y) corresponds to g(i, j) that is the top grid of the four grids
      //that slash m(x, y) involves.
      if (m[x][y] == '\\') {
        //Then top and right grids connect, so do left and bottom grids.
        g[Point(i, j)].push_back(Point(i, j + 1));
        g[Point(i, j + 1)].push_back(Point(i, j));
        g[Point(i + 1, j)].push_back(Point(i + 1, j + 1));
        g[Point(i + 1, j + 1)].push_back(Point(i + 1, j));
      }
      else {
        //Then top and left grids connect, so do right and bottom grids.
        g[Point(i, j)].push_back(Point(i + 1, j));
        g[Point(i + 1, j)].push_back(Point(i, j));
        g[Point(i, j + 1)].push_back(Point(i + 1, j + 1));
        g[Point(i + 1, j + 1)].push_back(Point(i, j + 1));
      }
      //while m(x, y) corresponds to g(i, j), m(x, y + 1) corresponds to
      //g(i - 1, j + 1)
      i--;
      j++;
    }
    //while m(x, y) corresponds to g(i, j), m(x + 1, y) corresponds to
    //g(i + 1, j + 1)
    i = oi + 1;
    j = oj + 1;
  }
  return g;
}
```

然后就是找出图中所有的环及其长度，这可以通过深度优先遍历得到，但要注意细节，否则仍是功亏一篑。代码如下：

```cpp
void dfs(const Grid & g, const Point & v, const Point & s,
    set<Point> & visited, map<Point, Point> & pred) {
  visited.insert(v);
  const vector<Point> & neighbours = g.find(v)->second;
  assert(neighbours.size() <= 2);
  for (int i = 0; i < neighbours.size(); i++) {
    const Point & n = neighbours[i];
    if (!visited.count(n)) {
      pred[n] = v;
      dfs(g, n, s, visited, pred);
    }
    else if (n == s && pred[v] != s) {
      pred[s] = v; //A cycle is detected!
    }
  }
}

vector<int> cycles(const Grid & g) {
  set<Point> visited;
  vector<int> cycles;
  for (Grid::const_iterator it = g.begin(); it != g.end(); ++it) {
    if (!visited.count(it->first)) {
      map<Point, Point> pred;
      dfs(g, it->first, it->first, visited, pred);
      //If a start point has a predecessor, it means a cycle.
      if (pred.count(it->first)) {
        cycles.push_back(pred.size());
      }
    }
  }
  return cycles;
}

void solve(const Maze & m, int i) {
  Grid g = mazeToGrid(m);
  vector<int> res = cycles(g);
  cout << "Maze #" << i << ":" << endl;
  if (res.size() > 0) {
    int max = *max_element(res.begin(), res.end());
    cout << res.size() << " Cycles; the longest has length " << max << "." << endl;
  }
  else {
    cout << "There are no cycles." << endl;
  }
  cout << endl;
}
```

完整代码在[GitHub](https://github.com/coin8086/programming-challenges/blob/master/ch9_ex4.cpp)。
