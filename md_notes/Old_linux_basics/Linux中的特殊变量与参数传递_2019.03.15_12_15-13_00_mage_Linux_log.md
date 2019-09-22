@[TOC](Linux中的特殊变量_2019.03.15_12:15-13:00_mage_Linux_log)
bash变量类型：
本地变量（局部变量）：作用域为当前shell进程
环境变量：作用域为当前shell进程及其子进程
位置变量：$1,$2,...
==shift 变换引用的参数==
特殊变量：
cat /etc/inittab /etc/fstab /etc/passwd
eg:  ./filetset.sh  /etc/inittab /etc/fstab /etc/passwd 后面三个为脚本./filetset.sh的参数
$1:/etc/inittab
$2:/etc/fstab
$3:/etc/passwd
分别对应不同的参数位置
###### 练习
写一个脚本，能接受一个参数（文件路径）；判定：此参数是否是是存在的文件，是就显示“OK”；否则显示“No such file.”
![filetest](https://img-blog.csdnimg.cn/20190315222322246.png)
![filetest](https://img-blog.csdnimg.cn/20190315222339922.png)
特殊变量：
$?  :命令执行状态返回值
$#  :参数的个数
$*  :参数列表
$@:参数列表
![filetest3](https://img-blog.csdnimg.cn/2019031522302422.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1lvdU9vcHM=,size_16,color_FFFFFF,t_70)
###### ==shift 变换引用的参数用法演示==
![shiftusage](https://img-blog.csdnimg.cn/20190315223906104.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1lvdU9vcHM=,size_16,color_FFFFFF,t_70)
###### 练习
写一个脚本，给脚本传递两个参数（整数）；显示此两个数之和，之积；
![参数传递与检测](https://img-blog.csdnimg.cn/20190315225128529.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1lvdU9vcHM=,size_16,color_FFFFFF,t_70)

