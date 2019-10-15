<center> <font face="黑体" size=7 color=grey>Chapter7.bash测试test详解</center>

<center><font face="黑体" size=4 color=grey> </center>

# 概述

- 任何相对完整的计算机语言都能够测试某个条件，然后根据测试的结果采取不同的动作。对于测试条件，Bash使用test命令、各种方括号和圆括号、if/then结构等来测试条件。

## 7.1. Test Constructs

- 一个if/then语句结构测试一个或多个命令的退出状态是否为0(因为在unix系统中0表示'执行成功')，如果为0，就执行语句后面的命令。

- Bash中有个专用的命令叫[(左中括号，bash特殊字符之一)。它是内置命令test别名，同时也是不是bash的内置命令，这样做可以提升bash的效率。该命令视其接受的参数为比较表达式或文件测试(测试文件是否存在、文件类型、文件权限等)并且返回一个对应于比较结果的退出状态(如果比较或测试结果为真则返回0，否则返回1)。

- 在bash2.02版本中，bash新增了\[[ ... ]]叫扩展的test测试命令，其进行比较时更贴合其他编程语言的风格。需要注意的是\[[是一个bash关键字而非命令。bash视\[[ $a -lt \$b ]]为单个元素，返回一个退出状态。

```bash
[root@centos8 ~]#type [[
[[ is a shell keyword
[root@centos8 ~]#type [
[ is a shell builtin
[root@centos8 ~]#type test
test is a shell builtin
[root@centos8 ~]#which [
/usr/bin/[
[root@centos8 ~]#which test
/usr/bin/test

[root@centos8 ~]#a=3
[root@centos8 ~]#b=4
[root@centos8 ~]#[[ $a -lt $b ]]
[root@centos8 ~]#echo $?
0
[root@centos8 ~]#a=5
[root@centos8 ~]#[[ $a -lt $b ]]
[root@centos8 ~]#echo $?
1
```

- '(( ... ))' 和 'let ...' 结构用来进行简单的数学运算，也会返回一个退出状态，退出状态决定于其里面的算术表达式展开后的结果是否是非0值。这些算术运算展开结构可能会被用来进行算术比较。

```bash
(( 0 && 1 ))                 # 逻辑与
echo $?     # 1     ***
# And so ...
let "num = (( 0 && 1 ))"
echo $num   # 0
# But ...
let "num = (( 0 && 1 ))"
echo $?     # 1     ***
(( 200 || 11 ))              # 逻辑或
echo $?     # 0     ***
# ...
let "num = (( 200 || 11 ))"
echo $num   # 1
let "num = (( 200 || 11 ))"
echo $?     # 0     ***
(( 200 | 11 ))               # 逐位或
echo $?                      # 0     ***
# ...
let "num = (( 200 | 11 ))"
echo $num                    # 203
let "num = (( 200 | 11 ))"
echo $?                      # 0     ***
# "let" 结构和双圆括号的返回状态相同。
```

- 注意：某个算术表达式的退出状态不是该算术表达式计算错误的值。

```bash
var=-2 && (( var+=2 ))   # 此处算术表达式值为0，退出状态为1
echo $?                   # 1
var=-2 && (( var+=2 )) && echo $var     # 此处由于算术表达式为0，退出状态为1；bash认为非0的退出状态是命令未执行成功，导致$$后面的echo命令不在执行
                          # Will not echo $var!
```

- An if can test any command, not just conditions enclosed within brackets.

```bash
if cmp a b &> /dev/null  # Suppress output.
then echo "Files a and b are identical."
else echo "Files a and b differ."
fi
# The very useful "if-grep" construct:
# ----------------------------------- 
if grep -q Bash file
  then echo "File contains at least one occurrence of Bash."
fi
word=Linux
letter_sequence=inu
if echo "$word" | grep -q "$letter_sequence"
# The "-q" option to grep suppresses output.
then
  echo "$letter_sequence found in $word"
else
  echo "$letter_sequence not found in $word"
fi
if COMMAND_WHOSE_EXIT_STATUS_IS_0_UNLESS_ERROR_OCCURRED
  then echo "Command succeeded."
  else echo "Command failed."
fi
```

> Example 7-1. What is truth?

```bash
#!/bin/bash
#  Tip:
#  If you're unsure how a certain condition might evaluate,
#+ test it in an if-test.
echo
echo "Testing \"0\""
if [ 0 ]      # zero
then
  echo "0 is true."
else          # Or else ...
  echo "0 is false."
fi            # 0 is true.
echo
echo "Testing \"1\""
if [ 1 ]      # one
then
  echo "1 is true."
else
  echo "1 is false."
fi            # 1 is true.
echo
echo "Testing \"-1\""
if [ -1 ]     # minus one
then
  echo "-1 is true."
else
  echo "-1 is false."
fi            # -1 is true.
echo
echo "Testing \"NULL\""
if [ ]        # NULL (empty condition)
then
  echo "NULL is true."
else
  echo "NULL is false."
fi            # NULL is false.
echo
echo "Testing \"xyz\""
if [ xyz ]    # string
then
  echo "Random string is true."
else
  echo "Random string is false."
fi            # Random string is true.
echo
echo "Testing \"\$xyz\""
if [ $xyz ]   # Tests if $xyz is null, but...
              # it's only an uninitialized variable.
then
  echo "Uninitialized variable is true."
else
  echo "Uninitialized variable is false."
fi            # Uninitialized variable is false.
echo
echo "Testing \"-n \$xyz\""
if [ -n "$xyz" ]            # More pedantically correct.
then
  echo "Uninitialized variable is true."
else
  echo "Uninitialized variable is false."
fi            # Uninitialized variable is false.
echo
xyz=          # Initialized, but set to null value.
echo "Testing \"-n \$xyz\""
if [ -n "$xyz" ]
then
  echo "Null variable is true."
else
  echo "Null variable is false."
fi            # Null variable is false.
echo
# When is "false" true?
echo "Testing \"false\""
if [ "false" ]              #  It seems that "false" is just a string ...
then
  echo "\"false\" is true." #+ and it tests true.
else
  echo "\"false\" is false."
fi            # "false" is true.
echo
echo "Testing \"\$false\""  # Again, uninitialized variable.
if [ "$false" ]
then
  echo "\"\$false\" is true."
else
  echo "\"\$false\" is false."
fi            # "$false" is false.
              # Now, we get the expected result.
#  What would happen if we tested the uninitialized variable "$true"?
echo
exit 0
```

> Exercise. Explain the behavior of Example 7-1, above.

```bash
if [ condition-true ]
then
   command 1
   command 2
   ...
else  # Or else ...
      # Adds default code block executing if original condition tests false.
   command 3
   command 4
   ...
fi
```

- When if and then are on same line in a condition test, a semicolon must terminate the if statement. Both if
and then are keywords. Keywords (or commands) begin statements, and before a new statement on the
same line begins, the old one must terminate.

```bash
if [ -x "$filename" ]; then
```

- Else if and elif
- elif
- elif is a contraction for else if. The effect is to nest an inner if/then construct within an outer one.

```bash
if [ condition1 ]
then
   command1
   command2
   command3
elif [ condition2 ]
# Same as else if
then
   command4
   command5
else
   default-command
fi
```

- The if test condition-true construct is the exact equivalent of if [ condition-true ]. As
it happens, the left bracket, [ , is a token[33] which invokes the test command. The closing right bracket, ] , in
an if/test should not therefore be strictly necessary, however newer versions of Bash require it.

- 特别指出：The test command is a Bash builtin which tests file types and compares strings. Therefore, in a Bash
script, test does not call the external /usr/bin/test binary, which is part of the sh-utils package.
Likewise, [ does not call /usr/bin/[, which is linked to /usr/bin/test.

```bash
bash$ type test
test is a shell builtin
bash$ type '['
[ is a shell builtin
bash$ type '[['
[[ is a shell keyword
bash$ type ']]'
]] is a shell keyword
bash$ type ']'
bash: type: ]: not found
If, for some reason, you wish to use /usr/bin/test in a Bash script, then specify it by full
pathname.
```

> Example 7-2. Equivalence of test, /usr/bin/test, [ ], and /usr/bin/[
