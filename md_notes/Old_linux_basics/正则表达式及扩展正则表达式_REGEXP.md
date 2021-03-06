﻿@[TOC](正则表达式及扩展正则表达式_REGEXP)
###### 文本查找的需要：

grep，egrep，fgrep  
	grep ：根据模式，搜索文本，并将符合模式的文本行显示出来。
Pattern：文本字符和正则表达式的元字符组合而成的匹配条件:''中的内容
	grep [OPTIOND] PATTERN [FILES...]
正则表达式：大多数文本处理工具都支持正则表达式，正则表达式是使计算变得智能化的重要途径，也是重要手段

###### 基本正则表达式：Basic REGEXP
.:
	[]:
	[^]:
###### 次数：
*:其前0次1次任意次
	\\?:0或1次，可有可无
	\\{m,n\\}:至少m次，至多n次：\{0,无穷大\}
###### 锚定：
\^:锚定行首：
	\$:锚定行尾：$
	\<:锚定词首：\\<,\b
	\>:锚定词尾：\\>,\b
分组与引用：
	\\(\\):
	\1,\2,\3,...
	
###### grep :使用基本正则表达式定义的模式来过滤文本的命令：
-i:忽略字符大小写
	-v:反向搜索，不显示模式匹配匹配到的字符，显示未匹配到的字符
	-o:只显示匹配到的字符串
	--color 显示颜色
	-E 使用扩展正则表达式
	-A n：（after）当某一行被grep所指定的模式匹配到以后，不但显示该行还会显示之后的n行 
	-B n：（before）当某一行被grep所指定的模式匹配到以后，不但显示该行还会显示之前的n行 
	-C n：（context）当某一行被grep所指定的模式匹配到以后，不但显示该行还会显示前后的各n行 
	

###### 位置锚定
锚定行首：^  其后面的任意字符必须在行首出现
锚定行尾：$  其前面的任意字符必须在行尾出现
空白行：^$  用于找出文件中空白行
锚定词首：\\<(\b):其后面的任意字符必须作为单词首部出现
锚定词尾：\\>(\b):其前面的任意字符必须作为单词的尾部出现
eg:\\<root\\>  在整个文件中搜索root这个词

###### 分组
\\(\\)：
eg:\\(ab\\)* :ab这个整体可以出现0次1次任意次
###### 后向引用
\1:引用第一个左括号以及与之对应的右括号所包括的所有内容 
grep '\\(l..e\\).*\1' test1.txt
\2:
###### 扩展正则表达式：Extended REGEXP

字符匹配：
	和基本正则表达式相同：.,[],[^],...
	
次数匹配：
*:
?:0或1次，可有可无
+:相当于\\{1,\\}，匹配其前面的字符至少一次
{m,n}:至少m次，至多n次：\\{0,无穷大\\},不再加\

位置锚定：
和基本正则表达式一样

分组：
():分组
\1,\2,\3,...

或则
|：or，
eg：C|cat：C或cat
eg：(C|c)at:Cat或cat
练习：
找出ifconfig命令结果中的1-255之间的整数
grep -E ’ ’
或egrep ‘’

grep,egrep,fgrep
###### fgrep:fast,不支持正则表达式，所以比较快
