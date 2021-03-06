---
title: A Multiplication Game
date: 2013-06-15T19:40:57+08:00
pc-id: 110505
uva-id: 847
---
分析：如果n<10,则Stan一步即可轻松获胜；当n>=10时，假设Stan能获胜，那么Ollie的最后一次乘积必须在[ceil(n/9), n)之间。设：

lower = ceil(n/9), upper = n

又设在此之前Stan的乘积是p，则Stan必须保证：

upper > x * p >= lower

其中x=2,3,...,9。即：

ceil(upper / x) > p >= ceil(lower / x)<!--more-->

取上式右边最大最小值及左边最小最大值，即：

ceil(upper / 9) > p >= ceil(lower / 2)

可保证x * p的值对**任意x**必在upper和lower之间。设：

upper = ceil(upper / 9), lower = ceil(lower / 2)

接下来该Ollie做乘法，**只要存在x**使得：

upper > x * p >= lower

其中p为Ollie的乘积，upper和lower为刚刚更新的upper和lower值，则Stan可以获胜，即：

9 \* p >= lower, 2 \* p < upper

即：

ceil(upper / 2) > p >= ceil(lower / 9)

重复以上过程，直到某次Stan的乘积下界lower不超过9为止。此时若

9 >= lower >= 2

则Stan有必胜策略，否则Ollie必胜。

```cpp
#include <iostream>
#include <cmath>

using namespace std;

bool stan_win(unsigned int n) {
  bool stan = true;
  if (n > 9) {
    //To ensure Stan's success, Ollie's multiplication result must be in
    //[lower, upper).
    unsigned int upper = n;
    unsigned int lower = ceil(n / 9.0);
    stan = !stan; //Indicate the current range is not Stan's.
    while (true) {
      if (stan && lower <= 9) {
        if (!(lower >= 2 && upper > lower))
          stan = false;
        break;
      }
      stan = !stan;
      if (stan) {
        //Stan must ensure no matter which number(x) Ollie chooses, x * p
        //is in desired range. p is Stan's multiplication result.
        upper = ceil(upper / 9.0);
        lower = ceil(lower / 2.0);
      }
      else {
        //Stan must ensure there is a number(x) so that x * p is in desired
        //range. p is Ollie's multiplication result.
        upper = ceil(upper / 2.0);
        lower = ceil(lower / 9.0);
      }
    }
  }
  return stan;
}

int main() {
  unsigned int n;
  while (cin >> n) {
    cout << (stan_win(n) ? "Stan wins." : "Ollie wins.") << endl;
  }
  return 0;
}
```

