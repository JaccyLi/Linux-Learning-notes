
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
# <center>Chapter3: bash shell 中的特殊字符详解
----
> # [sharp] # 井号

- ### 井号常用作注释符号

**1.注释示例**
```bash
# This line is a comment.
```
**2.某命令后注释，#号前需要添加一个空格**
```bash
echo "A comment will follow." # Comment here.
#                            ^ Note whitespace before #
```
**3.注释前亦可跟空白字符**
```bash
   # A tab precedes this comment.
```
**4.注释符号还可以被嵌入到带管道的命令当中**
```bash
initial=( `cat "$startfile" | sed -e '/#/d' | tr -d '\n' |\
           sed -e 's/\./\. /g' -e 's/_/_ /g'` )
# Delete lines containing '#' comment character.
# 该命令用于删除包含#号的行
```
**5.当然，在echo命令中被引用或者被转义的#号不会成为注释,#号也会出现在特定的参数替换结构中及一些数值常量表达式中**
```bash
echo "The # here does not begin a comment."
echo 'The # here does not begin a comment.'
echo The \# here does not begin a comment.
echo The # here begins a comment.
echo ${PATH#*:}       # 参数替换，不是注释
echo $(( 2#101011 ))  # 数制转换，不是注释

[root@centos7 /data/test]$echo ${PATH#*:} 
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
[root@centos7 /data/test]$echo ${PATH}    
/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
``` 
**6.标准的单双引用符号和转义符号("'\/)都能转义#号**

**7.某些特定的模式匹配操作也使用#号**

----
> # [semicolon] ; 分号
- ### 分号一般用作命令分隔符，允许多个命令处于同一行
```bash
echo hello; echo there
```
```bash
if [ -x "$filename" ]; then    #  Note the space after the semicolon.
#+                   ^^
  echo "File $filename exists."; cp $filename $filename.bak
else   #                       ^^
  echo "File $filename not found."; touch $filename
fi; echo "File test complete."
```
----
> # [double semicolon] ;; 双分号
 - ### 双分号用作case语句中的语句结束符
- bash4.0+的版本使用;;&或者;&作为结束符
```bash
case "$variable" in
  abc)  echo "\$variable = abc" ;;
  xyz)  echo "\$variable = xyz" ;;
esac
```
----
> # [period] . 英文句号
- ### 通常，英文句号.为bash builtin命令，等同于source
**1.作为文件名的一部分，当一个文件以.开头，则为隐藏文件，ls不会显示，使用ls -a**
```bash
bash$ touch .hidden-file
bash$ ls -l
total 10
 -rw-r--r--    1 bozo      4034 Jul 18 22:04 data1.addressbook
 -rw-r--r--    1 bozo      4602 May 25 13:58 data1.addressbook.bak
 -rw-r--r--    1 bozo       877 Dec 17  2000 employment.addressbook
bash$ ls -al
total 14
 drwxrwxr-x    2 bozo  bozo      1024 Aug 29 20:54 ./
 drwx------   52 bozo  bozo      3072 Aug 29 20:51 ../
 -rw-r--r--    1 bozo  bozo      4034 Jul 18 22:04 data1.addressbook
 -rw-r--r--    1 bozo  bozo      4602 May 25 13:58 data1.addressbook.bak
 -rw-r--r--    1 bozo  bozo       877 Dec 17  2000 employment.addressbook
 -rw-rw-r--    1 bozo  bozo         0 Aug 29 20:54 .hidden-file
```

**2.句号在目录中，一个句号.表示当前目录，两个句号..表示当前目录的父目录**
```bash
bash$ pwd
/home/bozo/projects
bash$ cd .
bash$ pwd
/home/bozo/projects
bash$ cd ..
bash$ pwd
/home/bozo/
```
**3.句号在移动文件的命令中表示目标文件夹，此时的目标文件夹常常是当前目录**
```bash
bash$ cp /home/bozo/current_work/junk/* .
# 拷贝junk/文件夹下的所有文件到当前目录
```
**4.字符匹配时，句号作为正则表达式的一部分表示匹配任意一个字符**

----
> # [double quote] ' " 单双引号
- **"STRING" preserves (from interpretation) most of the specia characters within STRING**
- **'STRING' preserves all special characters within STRING. This is a stronger form of quoting than "STRING"**
- **部分(弱)引用："STRING" 这种写法表示 解释器会认为STRING中的小部分特殊字符有特殊意义**
- **全(强)引用：'STRING' 这种写法表示 解释器会认为STRING中的所有特殊字符都无特殊意义**
```bash
[root@centos7 /data]$var=jjjj
[root@centos7 /data]$cat file
test
ddd
[root@centos7 /data]$sed "s/test/${var}/" file #双引号表示部分特殊字符具备特殊意义,此处${var}表示jjjj
jjjj
ddd
[root@centos7 /data]$sed 's/test/${var}/' file #单引号表示所有特殊字符均无特殊意义，此处${var}表示包含6个字符的字符串
${var}
ddd
[root@centos7 /data]$
```
----
> # [comma operator] , 逗号操作符
- ###  逗号操作符将多个数学运算表达式链接在一起，所有表达式都会被计算，但是只有最后一个表达式的结果被返回
```bash
[root@centos7 ~]$let "t2 = ((a = 9, 15 / 3))"
[root@centos7 ~]$echo $t2   # 此处返回值为15/3=5
5
[root@centos7 ~]$echo $a
9
```
- ### 逗号操作符亦可以用来连接字符串
```bash
for file in /{,usr/}bin/*calc
#             ^    Find all executable files ending in "calc"
#+                 in /bin and /usr/bin directories.
do
        if [ -x "$file" ]
        then
          echo $file
        fi
done

# /bin/ipcalc
# /usr/bin/kcalc
# /usr/bin/oidcalc
# /usr/bin/oocalc
```
----
> # [backslash] \ 反斜杠
- ### 用于单个字符的引用机制
```
\X 该写法将转义字符X，等价于'X'，反斜杠也会用于转义'和"。
```
> # [forward slash] / 斜杠
- ### 斜杠一般用作文件名路径分隔符
```bash
[root@centos7 ~]$cat /home/bozo/projects/Makefile
```
- ### 斜杠也是除法运算符


> # [backquotes] ` 反引号
- ### 反引号用作命令替换，`command` 这种结构使得command的执行结果可以赋给新的变量
```bash
[root@centos7 ~]$num=`seq 1 10`
[root@centos7 ~]$echo $num
1 2 3 4 5 6 7 8 9 10
```
> # [colon] : 冒号
- ### 冒号在shell中表示"NOP" (no op, a do-nothing operation)，一个不做任何操作的命令；":"冒号命令属于bash builtin类型，其命令退出状态为True（0）
```bash
[root@centos7 ~]$:
[root@centos7 ~]$echo $?
0
```
**1.冒号用于实现无限循环**
```bash
while :
do
   operation-1
   operation-2
   ...
   operation-n
done
# 等同于:
#    while true
#    do
#      ...
#    done
```
**2.在if/then语句中作为占位符**
```bash
if condition
then :   # 什么也不做，分支继续
else     # Or else ...
   take-some-action
fi
```
**3.在需要进行二进制操作的地方提供一个占位，**
```bash
[root@centos7 ~] : ${username=`whoami`}
# ${username=`whoami`}   不以: 开头则会给出错误提示
#                        unless "username" is a command or builtin...
[root@centos7 ~] : ${1?"Usage: $0 ARGUMENT"}  
```
**4.用参数替换来确定某个变量是否已经存在**
```bash
[root@centos7 ~]$: ${HOSTNAME?} ${USER?} ${MAIL?}
[root@centos7 ~]$echo $?
0
# 如果上面某个或多个必要的环境变量未设置，则会打印一条错误消息，此时我的电脑三个环境变量都已经存在，所以没有错误消息
```
**5.和重定向符号>配套使用，清除某个文件的内容，不改变其原有的权限属性-$: > file**
```bash
[root@centos7 /data/test]$cat hello
HELLO
[root@centos7 /data/test]$: > hello  # 此处清空hello文件，如果hello不存在，则创建之
[root@centos7 /data/test]$cat hello
[root@centos7 /data/test]$
```
**_注意_：上面用法等同于“cat /dev/null > hello”**

**然而，使用上面的方法不会产生子进程，因为“:”是一个builtin类型**

**如果和追加重定向符>>配合使用，则不对文件产生任何影响；无对应文件则创建之**

**6.分号还可以用作注释，但是bash会在以分号开头的注释中检查错误；而以#号开头的注释是关闭错误检查的**
```bash
[root@centos7 /data/test]$cat test.sh     
#!/bin/bash
#
: This is a comment that generates an error, ( if [ $x -eq 3] )  #以分号开头的注释含有错误代码
[root@centos7 /data/test]$bash -n test.sh 
test.sh: line 13: syntax error near unexpected token `('
test.sh: line 13: `: This is a comment that generates an error, ( if [ $x -eq 3] )' #bash检查出分号开头的注释存在错误
[root@centos7 /data/test]$
```
**7.分号还可以作为域分隔符，如文件:/etc/passwd和环境变量PATH**
```bash
[root@centos7 ~]$echo $PATH
/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
```
**8.分号也可以作为函数名，但是不推荐这种做法，会使得代码不易读**
```bash
:()              # 该函数的函数名为分号
{
  echo "The name of this function is "$FUNCNAME" "
  # Why use a colon as a function name?
  # It's a way of obfuscating your code.
}
```
**注意：在比较新的bash版本中已经不允许这样做，但是可以使用_下划线作为函数名**
**9.冒号可以用作空函数中的占位符**
```bash
not_empty ()
{
  :
} # Contains a : (null command), and so is not empty.
```
**注：该函数不做任何动作，但是不是空函数**

> # [bang] ! 感叹号
- ### 感叹号一般有取反和在bash命令行调用命令历史机制的作用
**1.感叹号用来对一个test测试条件或者命令退出状态取反，感叹号属于bash关键字**

**2.在不同的上下文中，!的出现也意味着间接变量引用**

**3.在bash命令环境中，!调用Bash历史机制**
```bash
 1092  cls
 1093  ll
 1094  history 
[root@centos7 ~]$!l    # 该写法表示bash执行history命令记录中以l开头的最近一次执行过的命令
ll
total 32
-rw-r--r--. 1 root root 4352 Sep 17 11:04 1
drwxr-xr-x. 3 root root   17 Aug 24 13:13 Desktop
drwxr-xr-x. 2 root root    6 Aug 24 13:06 Documents
drwxr-xr-x. 2 root root    6 Aug 24 13:06 Downloads
drwxr-xr-x. 2 root root    6 Aug 24 13:06 Music
drwxr-xr-x. 2 root root    6 Aug 24 13:06 Pictures
drwxr-xr-x. 2 root root    6 Aug 24 13:06 Public
drwxr-xr-x. 2 root root    6 Aug 24 13:06 Templates
drwxr-xr-x. 2 root root    6 Aug 24 13:06 Videos
-rw-------. 1 root root 2053 Aug 24 13:03 anaconda-ks.cfg
-rw-r--r--. 1 root root 2101 Aug 24 13:05 initial-setup-ks.cfg
-rwxr-xr-x. 1 root root 3121 Sep 12 00:04 reset.sh.bak0
-rw-r--r--. 1 root root    4 Sep  4 11:25 somaxconn~
-rw-r--r--. 1 root root    4 Sep  4 11:29 somaxcony~
-rw-r--r--. 1 root root    4 Sep  4 11:29 somaxconz~
[root@centos7 ~]$
```
> #  [asterisk] * 星号通配符
**1.星号在文件名通配操作中扮演通配符的角色，表示匹配某文件夹下的所有文件名；与其他具体字符结合表示匹配0个或者多个任意字符**
```bash
[root@centos7 /data]$ echo *
c_program py_scripts rpmPacksges scripts test test_scripts ttt.sh
[root@centos7 ~]$ echo /data/*
/data/c_program /data/py_scripts /data/rpmPacksges /data/scripts /data/test /data/test_scripts /data/ttt.sh
```
**2.星号在正则表达式中表示：匹配其前面的字符任意次，包括0次**  
**3.在算术运算操作中，星号表示乘法操作符**  
**4.\*\* 两个星号一起是运算符中的乘方操作符号，比如2\*\*8=256**  
**5.\*\* 两个星号一起在bash4.0版本以上内核中表示$\color{red}{扩展的文件通配操作}$，会递归通配文件**
```bash
#!/bin/bash4
# filelist.bash4
shopt -s globstar  # 必须使能 globstar, 否则 ** 没用.
                   # globstar 是bash4.0中新增的shell选项
echo "Using *"; echo
for filename in *
do
  echo "$filename"
done   # 列出当前目录的文件 ($PWD).
echo; echo "--------------"; echo
echo "Using **"
for filename in **
do
  echo "$filename"
done   # 递归列出完整的文件树.
exit

# 列出当前目录输出如下
Using *
allmyfiles
filelist.bash4
--------------
# 递归列出完整的文件树输出如下
Using **
allmyfiles
allmyfiles/file.index.txt
allmyfiles/my_music
allmyfiles/my_music/me-singing-60s-folksongs.ogg
allmyfiles/my_music/me-singing-opera.ogg
allmyfiles/my_music/piano-lesson.1.ogg
allmyfiles/my_pictures
allmyfiles/my_pictures/at-beach-with-Jade.png
allmyfiles/my_pictures/picnic-with-Melissa.png
filelist.bash4
```
----
> # [test operator] ? 测试操作符
**1.在特定的表达式中，问号表示对一个条件的测试**  
**2.在双括号结构中，问号表现为C风格三元操作符的组成部分**  

```bash
# condition?result-if-true:result-if-false
# 条件?条件为真的值:条件为假的值
(( var0 = var1<98?9:21 ))
#                ^ ^
# if [ "$var1" -lt 98 ]
# then
#   var0=9
# else
#   var0=21
# fi
```
**3.在参数替换表达式中，问号表示某变量是否已经存在**
```bash
${paramseter?err_msg}, ${parameter:?err_msg}
# 如果parameter已经存在，就使用其；否则打印err_msg退出脚本，并且退出状态为1
# 上面两种写法几乎同等，后面写法中的冒号表示只有当parameter已经被声明且为空时(null)就使用
```
**4.作为通配符，在文件名通配中表示匹配任何当个字符；在扩展正则表达式中表示匹配其前面的某单个字符。**
> # [$] 变量替换符(获取一个变量所存储的内容)
```bash
[root@centos7 /data/globbing]$var1=123
[root@centos7 /data/globbing]$var2=hello
[root@centos7 /data/globbing]$echo $var1; echo $var2
123
hello
```
> # [$] end-of-line 在正则达式中表匹配文本的行结束位置，常用于锚定；在linux系统中文本文件的行结束符也是\$
```bash
[root@centos7 /data/globbing]$ls |grep '.*[0-9]$'  # 表示匹配以数字结尾的文件名
10file.1
10file.2
1SdsflDSLFsdf677671
1SdsflDSLFsdf677672
{a-z}dsf3adsf1
DSdsflDSLFsdf677671
[root@centos7 /data/globbing]$ls |grep '.*[a-zA-Z]$'   # 表示匹配以字母结尾的文件名
10file.txt
1SdsflDSLFsdf67767A
1SdsflDSLFsdf67767B
a123321a
A123321A
a123321b
```
```bash
[root@centos7 /data/globbing]$echo hello > 10file.1
[root@centos7 /data/globbing]$cat -A 10file.1
hello$                                            # cat -A 查看文本的不可打印字符，包括tab键和行结束符$等。
```
> # [${}] 参数替换符,获取花括号中的变量所存储的内容；几乎和\$等同，在某些情况下使用\${}(例如：使用字符串连接不同的变量所存储的内容)

```bash
[root@centos7 /data/globbing]$echo $USER      # 环境变量USER，保存有当前用户的用户名，使用$USER获取
root
[root@centos7 /data/globbing]$echo ${USER}    # 此处功能同$
root
[root@centos7 /data/globbing]$your_id=${USER}-on-${HOSTNAME}    # 此处使用'-on-' 将USER和HOSTNAME存储的内容连接起来；获取它们的内容必须用${}
[root@centos7 /data/globbing]$echo "$your_id"
root-on-centos7.magedu.steve                 # 连接后的结果
```
> # [$' ... ']
- 该结构将展开单个或多个被转义的8进制或者16进制的值并转换为ASCII码或者Unicode字符：
```bash
[steve@centos7 ~]$echo $'\x21'
!
[steve@centos7 ~]$echo $'\x22'                # 十六进制x22代表ASCII码中的双引号 "
"
[steve@centos7 ~]$echo $'\037'

```

> # [$*, $@] 位置参数，存储所有的位置参数，有区别
- $* 将所有位置参数视为单个字符串
- $@ 每个位置参数存储为单独引用的字符串，分开对待每个位置参数
  
> # [$?] 该环境变量存储退出状态；可以是命令、函数或者脚本的退出状态
- 脚本的退出状态为脚本中最后一条命令的退出状态
- 函数退出状态也为最后一条命令的退出状态
- 一般成功执行退出状态为0；命令执行失败退出状态为1-255之间的整数.
```bash
[root@centos7 /data/test]$cat exit_status.sh 
#!/bin/bash
echo hello
echo $?    # 打印hello成功，放回的退出状态值为0.
lskdf      # Unrecognized command.
echo $?    # 无该命令命令，执行失败，退出状态非0.
echo
exit 113   # 脚本结束后使用echo $? 查看，脚本退出状态为113.
[root@centos7 /data/test]$bash exit_status.sh 
hello
0
exit_status.sh: line 4: lskdf: command not found
127
[root@centos7 /data/test]$echo $?
113
```
> # [$$] 为PID变量，存储其出现在的脚本所属的进程的进程号

```bash
[root@centos7 ~]$pstree -p |grep sshd.*bash
           |-sshd(1164)---sshd(1842)---bash(1848)---bash(6007)-+-grep(6043)
[root@centos7 ~]$echo $$                        # 当前所在bash进程为6007
6007
[root@centos7 ~]$exit                           # 退出6007号bash进程
exit
[root@centos7 ~]$echo $$                        # 此时$$记录1848
1848
```
> # [()] 圆括号

**1.圆括号可以用来执行其包括的一组命令，各个命令使用分号；隔开**
```bash
[root@centos7 ~]$(a=hello; echo $a)
hello
```
- 注意；结构(command1;command2)中，shell会生成一个子shell进程来运行括号内的多个命令。括号内的变量(子shell中)不被括号外的命令读取，父进程(父shell)无法读取子进程的变量。

```bash
a=123
( a=321; )            
echo "a = $a"   # a = 123
# "a" 可视为本地变量.
```

**2.圆括号用于初始化数组**
```bash
Array=(element1 element2 element3)
```

> # [{xxx,yyy,zzz,...}] 花括号展开
**1.有如下用法**
```bash
echo \"{These,words,are,quoted}\"   # " 添加前缀和后缀(prefix and suffix)
# "These" "words" "are" "quoted"
cat {file1,file2,file3} > combined_file
# 链接三个文件 file1, file2, and file3 成一个文件combined_file.
cp file22.{txt,backup}
# Copies "file22.txt" to "file22.backup"
```
**2.使用花括号展开时如果包含空格需要转义**
```bash
[root@centos7 /data/test]$echo {file1,file2}\ :{\ A," B",' C'}
file1 : A file1 : B file1 : C file2 : A file2 : B file2 : C
```
