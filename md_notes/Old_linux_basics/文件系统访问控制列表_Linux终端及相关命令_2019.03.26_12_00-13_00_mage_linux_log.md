@[TOC](Linux终端)
tom:
	tom属主， tom基本组
jerry想访问tom的文件-->tom设置权限other：rw-

## FACL:Filesystem Access Control List
利用文件扩展属性保存额外的访问控制权限

## 两个命令
### setfacl
-m 设定
	u:UID:perm  #设定该用户对此文件拥有某权限
	g:GID:perm  #设定该组对此文件拥有某权限
	eg:setfacl -m u:hadoop:rw- inittab
		setfacl -m g:mygroup:rw- inittab
-x 取消
setfacl -x u:hadoop inittab
==取消权限只需要指定用户名或者组名即可==
### getfacl
eg：getfacl /etc/inittab
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190326215437949.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1lvdU9vcHM=,size_16,color_FFFFFF,t_70)
mask？
对当前文件来说，随着用户附加的权限变化
回忆：umask？

## 终端类型
console：控制台
pty：物理终端
tty#：虚拟终端
ttys#：串行终端
pts/#:伪终端
**终端必须要关联到某个硬件**；此前早期mainframe时代，人们使用计算机一般都是使用一个显示器和键盘通过分屏接口链接到mainframe使用计算机资源；此时大部分终端都是模拟出来的。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190326215408288.png)
## whoami命令
显示当前登录有效的用户
## who命令
当前登录的用户都有哪些；三个字段：用户、终端、登录时间
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190326215408288.png)
### who -H  #显示头部，如果远程连接，COMMENT字段显示远程终端地址
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190326220619228.png)
### who -r #显示运行级别，及上一次的运行级别
**注意：su过去的用户虽然使用whoami命令可以显示，但是该用户并不是登录用户，使用who查看不了**
###### 练习
每隔5秒，就查看某个用户是否登录，登录就显示出来；没有登录就继续每隔5秒检查一次；
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190326223809518.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1lvdU9vcHM=,size_16,color_FFFFFF,t_70)

## w命令
当前登录的用户及其行为

## last命令
用于显示/var/log/wtmp文件中的信息，用户的登录历史及系统重启历史
显示谁在什么时候通过什么终端登录过主机
last -n 3  #只显示最近3此的登录选项

## lastb命令
用于显示/var/log/btmp文件中的信息，用户错误的尝试登录历史
last -n 3  #只显示最近3此的登录尝试

## lastlog命令
lastlog -u USERNAME #显示特定用户最近的登录信息

## basename命令
取得一个路径的基名
$0  #特殊变量，表示命令本身；或者执行脚本时脚本路径及名称
更改当前主机名使用： hostnam NEWHOSTNAME

## mail命令
linux系统默认安装邮件服务，系统会有很多的自动任务，监控系统资源的使用情况，比如硬盘快满了，就会发邮件给用户或者管理员，告知其资源使用情况；系统内部各个用户发送。
命令行直接键入mail进入mail服务；
**mail -s “Hello ，Steve ！” USERNAME < /etc/fstab**
*#以主题Hello ，Steve ！给 USERNAME发送一封内容为/etc/fstab中的邮件；*
**cat /etc/fstab | mail -s “Hello ，Steve ！” USERNAME** 
*#以某文件内容当作邮件正文。*

## hostname命令
获取当前主机名，实时的

## 练习
如果当前的主机名不是steve.com就改为steve.com
[ \`hoatname\` != 'steve.com' ] && hostname steve.com

如果当前的主机名是hostname.com就改为steve.com
[ \`hoatname\` == 'hostname.com' ] && hostname steve.com

如果当前的主机名为空或者为none或者为hostname.com；就改为steve.com
[ -z \`hoatname\` ] || [ \`hoatname\`== 'none' -o  \`hoatname\` = 'hostname.com' ] && hostname steve.com

## $RANDOM 环境变量
echo $RANDOM   #生成0－36768之间的随机数


随机数生成器：熵池：随时保留有当前系统上的随机数（敲键盘的时间间隔）；服务器会把硬件中断的时间间隔保存为随机数
/dev/random  #默认到熵池取随机数，熵池空后会阻塞random  ；安全性更高
/dev/urandom   #默认到熵池取随机数，熵池空后会使用软件模拟 ；安全性较低

## 练习
利用$RANDOM 生成10个随机数，找出最大值最小值
![random.sh](https://img-blog.csdnimg.cn/20190326230330539.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1lvdU9vcHM=,size_16,color_FFFFFF,t_70)
![result](https://img-blog.csdnimg.cn/20190326230349575.png)
