<center> <font face="黑体" size=7 color=grey>Chapter6.bash退出和退出状态详解</center>

<center><font face="黑体" size=4 color=grey> </center>

# 概述

- 就像在C程序中一样，exit命令会停止脚本。其也可以返回一个跟在其后的值，该值可以被脚本的父进程访问。

- 在bash中每个命令运行结束都返回一个退出状态值(有时被称为返回状态或退出代码)。运行成功的命令返回一个0，而运行失败的命令返回一个非0值，通常被解释为错误码。良好的UNIX命令、程序和工具运行成功就返回一个0退出代码。也有一些例外。

- 同样地，脚本中的函数和脚本本身也会返回退出代码。函数中或者脚本的最后一行代码的退出代码决定函数或者脚本的退出状态。在脚本中，命令：exit nnn 可以用来将退出状态码nnn传给shell(nnn必须是0 - 255之间的整数)

# 详解

> 当一个脚本末行为不带参数的exit的命令时，该脚本的退出状态为最后一条命令的退出状态。(exit命令前面的那条)

```bash
#!/bin/bash
COMMAND_1           ## 第一条命令
. . .
COMMAND_LAST        ## 最后一条命令
# 该脚本以最后这条命令的退出状态作为整个脚本的退出状态。
exit
```

> 在脚本中exit命令的等价写法是：exit $? ；或者直接不写。

```bash
#!/bin/bash
COMMAND_1
. . .
COMMAND_LAST
# 同样，该脚本以最后这条命令的退出状态作为整个脚本的退出状态。
exit $?
```

```bash
#!/bin/bash
COMMAND1
. . . 
COMMAND_LAST
# 同样，该脚本以最后这条命令的退出状态作为整个脚本的退出状态。
```

- \$? 会自动读取记录最后一条执行的命令的退出状态。当一个函数运行后，$? 返回函数中最后一条执行的命令的退出状态。你可以理解为这是bash给函数一个"返回值"的做法。

- 在管道结构中，\$? 记录最后一条命令的退出状态。

- 当脚本执行结束后，命令行的\$? 会记录脚本的退出状态，也就是脚本的最后一条命令的执行退出状态；同样约定为0表示脚本执行成功，1-255表示失败。

> 例6-1. 退出/退出状态(exit / exit status)

```bash
#!/bin/bash
echo hello
echo $?    # echo 命令成功执行，退出状态为0
lskdf      # 无法识别的命令
echo $?    # 返回非0的退出状态
echo
exit 113   # 返回113的退出状态给shell.
           # exit 113这条命令执行结束后使用"echo $?"来验证退出状态值.
#  一般约定'exit 0'表示执行成功,
#  含有特殊意义的退出状态值，见附录page：802(See the "Exit Codes With Special Meanings") appendix.
```

- \$? 用来测试脚本中某个命令的退出状态非常实用。

> 注意：感叹号!,表示逻辑非，可以对某个测试条件取反以影响其退出状态。

> 例6-2. 实用!来对测试条件取反

```bash
true    # "true" 为bash内置命令.
echo "exit status of \"true\" = $?"     # 0
! true
echo "exit status of \"! true\" = $?"   # 1
# 需要注意的是，"!"和命令之间需要一个空格。
#    !true   leads to a "command not found" error
#  在命令行中，处于命令前的!会触发bash的历史机制
[root@centos8 ~]#true 
[root@centos8 ~]#! true     # 带空格，对true(真)命令取逻辑非，为假
[root@centos8 ~]#echo $?
1
[root@centos8 ~]#true
[root@centos8 ~]#!true      # 不带空格，表示运行上一条以true开头的命令
true
[root@centos8 ~]#echo $? 
0
[root@centos8 ~]#
# No error this time, but no negation either.
# It just repeats the previous command (true).
# =========================================================== #
# 在管道前加!,对返回状态值取反
ls | bogus_command     # bash: bogus_command: command not found
echo $?                # 127
! ls | bogus_command   # bash: bogus_command: command not found
echo $?                # 0
#####################################################
# 需要注意的是：!并没有改变管道的执行，只是改变退出状态。#
#####################################################
# Only the exit status changes.
# =========================================================== #
# Thanks, Stéphane Chazelas and Kristopher Newsome.
```

- 注意：某些退出状态码是有保留意义的，不应当被用户在脚本中指定。（书的page:802）


