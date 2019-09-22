@[TOC](shell脚本练习)
###### 写脚本时每一个命令先在命令行测试是否ok
###### 练习1
添加user1到user10，10个用户，只有在用户存在的情况下才添加
```shell
#！/bin/bash
# 
for I in {1..10}; do
if id user\$I &> /etc/nulll; then
	echo "user$I exists."
else 
	useradd user\$I
	echo user\$I | passwd --stdin user\$I &> /etc/null
	echo "Add user user$I finished."
fi
done
```
 
###### 练习2
删除user1到user10，10个用户，只有在用户存在的情况下才删除
```shell
#！/bin/bash
# 
for I in {1..10}; do
if id user\$I &> /etc/nulll; then
	userdel -r user\$I
	echo "Delete user user$I finished."
else 
		echo "user$I not exists."
fi
done
 ```
###### 练习3
扩展：接受参数
--add：添加10个用户
--del：删除10个用户
```shell
#!/bin/bash
\#administrators.sh 
if [ $# -lt 1 ]; then
	echo "Usage:administrators.sh ARG"
exit 7
fi
if[ $1 = '--add' ]; then
	for I in {1..10}; do
		if id user\$I &> /etc/nulll; then
			echo "user$I exists."
		else 
			useradd user\$I
			echo user\$I | passwd --stdin user\$I &> /etc/null
			echo "Add user user$I finished."
		fi
	done
elif
	for I in {1..10}; do
		if id user\$I &> /etc/nulll; then
			userdel -r user\$I
			echo "Delete user user\$I finished."
		else 
			echo "user$I not exists."
fi
done
else
	echo "unknow ARG"
	EXIT 8
fi
```
###### 练习4
扩展：接受参数
用户指定要添加的用户和要删除的用户
--add 
--del
```shell
#!/bin/bash
\#adminusers.sh
#实现用法：adminusers.sh --add user1,user2,user3,hello,hi 
echo $1
if [ $1 == '--add' ]; then
for I in \`echo $2 | sed 's/,/ /g\`; do
	if id $I &> /edev/null; then
		echo "\$I exists."
	else
		useradd $I
		echo $I | passwd --stdin $I &> /dev/null
		echo "add $I finished."
	fi
done
elif [ $1 = '--del' ]; then
	for I in \`echo $2 | sed 's/,/ /g'`; do
		if id $I &> /edev/null; then
			userdel -r user\$I
			echo "Delete user user\$I finished."
		else 
			echo "user$I not exists."
		fi
done
elif [ $1 = '--help' ]; then
echo "Usage: adminusers.sh --add USER1,USER2,... |  --add USER1,USER2,... | --help "
else
	echo "unkonwn options."
fi	
```
