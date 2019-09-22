@[TOC](bash编程之case语句及脚本选项)

## 面向过程的编程
控制结构
顺序结构
选择结构
循环结构

### 选择结构
if：单分支；双分支；多分支
**单分支**
if CONDITION; then
statement 
fi

**双分支**
if CONDITION; then
statement 
else
statement 
fi

**多分支**
if CONDITION; then
statement 
elif CONDITION2; then
statement 
else
statement 
fi

#### case语句：选择结构
case SWITCH in 
value1）
statement 
...
；；
value2）
statement 
...
；；
*）
statement 
...
；；
esac
value#是SWITCH的某个值；当作字符比较，所以以前的globbing字符都可以使用[a-zA-Z],...


### 练习1：
```bash
#!/bin/bash
#
#case.sh
case $1 in 
[0-9])
echo "a num" ;;
[a-z])
echo "lower" ;;
[A-Z])
echo "upper" ;;
*)
echo "special char" ;;
esac
```
### 练习2：
```bash
#!/bin/bash
#
#service.sh
case $1 in
'start')
echo "start server...";;
'stop')
echo "stop server...";;
'restart')
echo "reatart server...";;
'status')
echo "running...";;
*)
echo "usage:\`bashname $0` {start | stop | restart | status}"
esac
```
### 练习3：
写一个脚本，可以接受选项及参数；之后获取每一个选项及选项的参数；并根据选项及参数作出特定操作
参考 adminusers.sh --add tom,jerry --del tom,blair -v|--verbose -h|--help
```bash
#!/bin/bash
#
#debug.sh
DEBUG=0
ADD=0
DEL=0
if [ $# -gt 0 ]; then
for I in \`seq 0 $#\`; then
case $1 in 
-v|--verbose)
DEBUG=1
shift 
;;        #跳过引用的第一个变量，接下来$1将引用所给的第二个变量
-h|--help)
echo "Usage:\`basename $0\` --add USERLIST --del USERLIST -v | --verbose -h | --help"
exit 0
;;
--add)
ADD=1
ADDUSERS=$2
shift 2
;;
--del)
DEL=1
DELUSERS=$2
shift 2
;;
*)
echo "Usage"\`basename $0` --add USERLIST --del USERLIST -v | --verbose -h | --help";;
exit 7
;;
esac
fi
done

if [ $ADD -eq 1]; then
	for USERS in \`echo \ $ADDUSERS  | sed s@,@  @g`; do  #把所给的用户列表中逗号替换为空格
		if id $USER &> /dev/null; then
		[ $DEBUG ] && ehco "User $USER exists."
		else
		useradd $USER
		[ $DEBUG ] && echo "Add user $USER finished."
	fi
done

if [ $DEL -eq 1]; then
	for USERS in \`echo \ $DELUSERS  | sed s@,@  @g`; do  #把所给的用户列表中逗号替换为空格
		if id $USER &> /dev/null; then
		userdel $USER
		[ $DEBUG ] && ehco "Delete user $USER finished."
		else
		[ $DEBUG ] && echo "User $USER exists."
	fi
done
```
### 练习4:
写一个脚本showlogged.sh，其用法为：
showlogged.sh -v -c -h|--help
其中，-h选项只能单独使用，用于显示帮助信息；-c选项时，显示当前系统登录的所有用户数；如果同时使用了-v选项，则显示登录的用户数后显示登录的用户的相关信息：如：
Logged users：4.
They are: 
root   tty2  Feb 18 02:41
root   pts/1 Mar  8  08:36 (192.168.110.177) 
root   pts/5 Mar  8  05:25 (192.168.110.177) 
hadoop   pts/7 Mar  8  12:28 (192.168.110.177) 

```bash
#!/bin/bash
#
declare -i SHOWNUM=0
declare -i SHOWDETAIL=0

for I in \`seq 1 $#\`; do
if [ $# -gt 0 ]; then 
case $1 in
-h|--help)
	echo "Usage:\`basename $0\` -h|--help -c|--counts -v|verbose"
    exit 0;;
-v|--verbose)
	let $SHOWDETAIL=1
	shift
	;;
-c|--counts)
	let SHOWNUM=1;;
*)
	echo "Usage:\`basename $0\` -h|--help -c|--counts -v|verbose"
esac
fi
done

echo $SHOWNUM $SHOWDETAIL 

if [ $SHOWNUM -eq 1 ]; then
	echo "Logged users:	\`who | wc -l\`."
	if [ $SHOWNUM -eq 1 ]; then
		echo "They are:	"
		who
	fi	
fi
```


