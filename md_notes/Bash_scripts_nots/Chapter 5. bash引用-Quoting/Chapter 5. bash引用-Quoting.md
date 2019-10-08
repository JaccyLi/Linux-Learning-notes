# 概述

- 引用的字面意思就是，用引号括住一个字符串。这可以保护字符串中的特殊字符不被shell或shell脚本重新解释或扩展。(如果一个字有不同于其字面意思的解释，它就是“特殊的”。例如：星号*除了本身代表\*号以外还表示文件通配和正则表达式中的通配符)。

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

- 在涉及到命令替换时，引用可以让echo输出带格式的命令结果

```bash
bash$ echo $(ls -l)                 # 无引号命令替换
total 8 -rw-rw-r-- 1 bo bo 13 Aug 21 12:57 t.sh -rw-rw-r-- 1 bo bo 78 Aug 21 12:57 u.sh
bash$ echo "$(ls -l)"               # 被引用的命令替换
total 8
 -rw-rw-r--  1 bo bo  13 Aug 21 12:57 t.sh
 -rw-rw-r--  1 bo bo  78 Aug 21 12:57 u.sh
```

## 5.1. 引用变量(Quoting Variables)
- 当我们使用\$引用一个变量时，比较建议的做法是使用双引号将其括起来。这样做可以避免bash再次解析双引号中的特殊字符（只不过：\$、反引号`、和反斜杠\仍然会被bash解析）。
Keeping $ as a special character within double quotes permits referencing a quoted variable
("$variable"), that is, replacing the variable with its value (see Example 4-1, above).