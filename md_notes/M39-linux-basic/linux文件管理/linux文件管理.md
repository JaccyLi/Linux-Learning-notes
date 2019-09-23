@[TOC](<center><font size=214 face=黑体 color=grey> linux文件管理 </font></center>)




练习

```bash
1、显示/var目录下所有以l开头，以一个小写字母结尾，且中间出现至少一位数字的文件或目录
    ls -a /var/l*[0-9]*[[:lower:]]
2、显示/etc目录下以任意一位数字开头，且以非数字结尾的文件或目录
    ls -a /etc/[[:digit:]]*[^[:digit:]]
3、显示/etc/目录下以非字母开头，后面跟了一个字母及其它任意长度任意字符的文件或目录
    ls -a /etc/[^[:alpha:]][[:alpha:]]*
4、显示/etc/目录下所有以rc开头，并后面是0-6之间的数字，其它为任意字符的文件或目录
    ls -a /etc/rc[0-6]* -d
5、显示/etc目录下，所有以.d结尾的文件或目录
    ls -a /etc/*.d -d
6、显示/etc目录下，所有.conf结尾，且以m,n,r,p开头的文件或目录
    ls /etc/[mnpr]*.conf
7、只显示/root下的隐藏文件和目录
    ls -d .[^.]*
8、只显示/etc下的非隐藏目录
    ls /etc/*/ -d
```

