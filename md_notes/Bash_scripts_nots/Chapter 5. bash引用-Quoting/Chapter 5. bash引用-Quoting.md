# 概述

- 引号的意思就是，用引号括住一个字符串。这可以保护字符串中的特殊字符不被shell或shell脚本重新解释或扩展。(如果一个字有不同于其字面意思的解释，它就是“特殊的”。例如：星号*除了本身代表\*号以外还表示文件通配和正则表达式中的通配符)。

```bash
[root@centos8 ~]$ ls -l P*
Pictures:
total 0
Public:
total 0
[root@centos8 ~]$ ls -l 'P*'
ls: cannot access 'P*': No such file or directory
```

- 在生活中用语或者书写，当我们使用双引号"引用"一个句子时，我们会区别对待该句子并赋予其特殊意义；在Bash脚本中，当我们使用双引号"string"引用一个字符串时，我们同样区别对待并保护其字面意思（一般性的意思）。

- 特定的编程语言和工具会重新解释或者展开处于引号中的特殊的字符。一个非常重要的
- Certain programs and utilities reinterpret or expand special characters in a quoted string. An important use of
quoting is protecting a command-line parameter from the shell, but still letting the calling program expand it.