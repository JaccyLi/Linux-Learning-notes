
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
# Linux学习日志_基础命令
<LINUX LEARNING LOG>

## Linux 哲学：
		1.一切皆文件
		2.使用纯文本文件保存软件配置信息
		3.功能单一的小程序组合完成复杂任务

###### 测试shell脚本是否有语法错误
==bash -n 脚本名称==
*只能大致的测试出一些明显语法错误*
###### bash单步执行脚本
==bash -x 脚本名称==
*写大段脚本时常用*

pwd:printing working directory
ls

	-l:长格式
		文件类型：
		-:普通文件
		d:目录文件
		b:块文件（block）
		c:字符串文件（character）
		l:符号连接文件（symbolic link files）
		p:命令管道文件（pipes）
		s:套接字文件（socket）
		文件权限：9位，每三位一组：rwxr--r--:rwx(读、写、执行)(属主)，r--(属组)，r--(其它)
		文件硬连接的次数
		文件的属主（owner）
		文件的属组（group）
		文件大小（size），单位是字节
		时间戳（timestamp）：最近一次被修改的时间
			访问：access
			修改：modify，文件内容发生改变
			改变（属性或者元数据改变）：change，metadata，元数据（属性数据）
	-h:文件大小单位换算  ls -l -h
	-a:显示以.开头的隐藏文件(-A:不包含.和..)
	-d 查看目录
	.:表示当前目录（英文句号）
	..:表示父级目录
	
	-i:index node，inode(索引节点)
	-r:逆序显示文件
	-R:递归显示（recursive）
	COMMAND --help
	
命令手册：manual

	man COMMAND  
	man分章节：
	1：用户命令
	2：系统调用
	3：库调用
	4：特殊文件（设备文件）
	5：文件格式（配置文件的语法）
	6：游戏
	7：杂项：（Miscellaneous）
	8：管理命令(/sbin , /usr/sbin , /usr/local/sbin)
	whatis  显示命令在手册哪个章节


man手册中命令解释：

	<>： 必须给出的选项
	[]： 可以省略
	...:可以出现多次
	|：多选一	
	{}：分组，无特殊意义
		SYNOPSIS:用法说明，包括可用的选项
		DESCRIPTION:命令功能详尽说明，可能包括每个选项的意义
		OPTIOND:说明每个选项的意义
		FILES:此命令相关的配置文件
		EXAMPLES:使用示例
		SEE ALSO :另外参照

翻屏：

	向后翻一屏幕：SPACE
	向前翻一屏幕：b
	向后翻一行：ENTER
	向前翻一行：k
查找：

	/KEYWORD:向前查找
	n:下一个
	N:前一个
	q:退出
	?KEYWORD:向后查找

###### hwclock （一般使用：hwclock -r  读取硬件时间）

	-w:将系统时间同步到硬件时间
	-s:将硬件时间同步到系统时间
	
在线手册/文档：
	info COMMAND

file 命令

###### 文件系统：

	rootfs:根文件系统
	FHS:Linux
			/boot:放系统启动相关的文件，如内核、initrd、grub（bootloader）
		/dev:设备文件
			设备文件：（字体黄色，背景黑色为特殊文件作为访问设备的入口）
			块设备：随机访问，数据块
			字符设备：线性访问，按字符为单位
			设备号：主设备号（major）和次设备号（minor）
		/etc:配置文件存放文件夹
		/home:用户家目录，每个用户的家目录默认为/home/USERNAME
		/root:管理员的家目录
		/lib:库文件及内核模块文件目录
				/lib/modules:内核模块
			库文件：静态库
					动态库（win:.dll linux:.so(shared object)）
		/media:挂载点目录，移动设备
		/mnt:挂载点目录，额外的临时文件系统
		/opt:可选目录，第三方程序的安装目录
		/proc:伪文件系统，内核映射文件
		/sys:伪文件系统，跟硬件设备相关的属性映射文件
		/tmp:临时文件，/var/temp
		/var:可变化的文件，会随系统使用时间增大
		/bin:可执行文件，用户命令
		/sbin:管理命令
		/usr:	universal shared read-only
			/usr/bin
			/usr/sbin
			/usr/lib
			/usr/lib
			
		/usr/local:
			/usr/local/bin
			/usr/local/sbin
			/usr/local/lib


文件夹及文件命名规则：

	1.长度不能超过255个字符
	2.不能使用/当文件名
	3.严格区分大小写

	相对路径：与当前位置有关
	绝对路径：从根目录开始


使用操作系统干些什么？

文件管理
运行程序
内存管理
设备管理
软件管理
进程管理
网络管理
目录管理

			ls 
			cd
			pwd
	文件创建和删除
		mkdir:创建空目录（路径最后的那个目录才是创建的）
			-p：一次性创建多层的目录
			-v：详细信息：创建多层的目录展示每层的创建情况
		eg:/mnt/test/x/m,y
		mkdir -pv /mnt/test/x/m  /mnt/test/y
		mkdir -pv /mnt/test/{x/m,y}
		rmdir：-p 删除一脉单承的目录
	命令行展开：
			/mnt/test/
			a_b,a_c,d_b,d_c
			(a+d)(b+c) = ab + ac + db + dc
		mkdir -pv /mnt/test/{a,d}_{b,c}	
		
		touch:改变时间戳
			-a
			-m
			-t	
			-c
		stat:展示文件或文件系统状态	
		tree:查看目录树

	ASCII:
		128个不同字符：
			7位二进制
			计算机存储数据基本单位：字节8位

nano；简单的文本编辑器

###### rm:删除

			-i 交互式，询问是否删除 
			-f 强制删除
			-r 递归删除目录及文件
			-rf 直接删除目录不提示
		rm -rf / 删除根目录及其所有目录文件，所有文件会被清空，无法重启系统，绝对致命！！！
		
###### cp:copy  （默认只复制文件）

		cp SRC DEST
			-r 递归复制一个目录及目录下所有文件
			-R 递归复制一个目录及目录下所有文件
			-i
			-f
			-p
			-P 保持复制的链接而不拷贝链接指向的文件
			-a 归档复制，常用于备份 （archive）
		cp file1 file2 file3(only file3 is destination)	
		一个文件到一个文件
		多个文件到一个目录
		cp /etc/{passwd,inittab,rc.d/rc.sysinit} /temp 复制三个文件到/temp/
		
###### mv:move

		移动文件
		mv SRE DEST
		mv -t DEST SRC
		mv file1 file2(file1 被重命名为 file2)
		
###### install:（复制后有执行权限）

			-d DIRECTORY... 创建目录
		install SRC(文件) DEST 复制文件	
		install -t DEST(文件) SRC
		目录管理总结：ls cd pwd mkdir rmdir tree
		文件管理总结：touch cat file (查看文件内容类型) rm cp mv nano 
		日期时间：date hwclock clock cal
	



文本处理命令：cat,more,less,head,tail,cut,sort,uniq,grep
			对于Linux系统而言，文本文件行结束符是$
			windows的文本行结束符是“$+回车”
			查看文本类：
			cat tac more less head tail
cat:链接并显示

				-n
				-E
			tac:从最后一行开始显示
			head:查看前n行（默认10行）
			tail:查看后n行（默认10行）
				-n
				tail -f :查看文件尾部，不退出，等待显示后续追加至此文件的新内容
				分屏显示：
			more,less

				处理文本类：
				cut,join,sed,awk

讲cut之前：
database:数据库 
		关系型数据库：
					表：二维表 可以没有行不能没有列
					
###### cut:

		-d:指定字段分隔符，默认为空格（如-d : 表示用：做分隔符）
		-f:指定要显示的字段
			-f1:显示第一个字段
			-f1,3:显示第一和第三个字段
			-f1-3:显示第一到第三个字段
			
###### 文本排序：sort（不影响源文件，只影响显示）

		默认anASCII码顺序升序
		-n 数值大小升序排序
		-r 降序
		-t 字段分隔符
		-k 以那个字段为关键字进行排序
		-u 排序后相同的行只显示一次  //如果是不相邻的行则不认为是相同行
		-f 排序时忽略字符大小写
	sort -u	/...= uniq /...
	
	uniq -d 只显示重复的行
		 -D 显示所有重复行
		 -c 显示所有行，并且显示某行重复的次数

		 
###### 文本统计：wc(word count)

			-l 行数
			-w 单词数
			-c 字节数
			-L 最长一行
			

###### 字符处理：tr  转换或删除字符

		tr 'ab' 'AB'  将输入的字符含有ab的转换为AB 	
		< 输入重定向
		tr 'ab' 'AB' < /home/test.txt  将 /home/test.txt 中所有ab转换为AB
		tr -d 删除出现在字符集中的字符


		
		



###### bash及其特性:

	shell :外壳，可执行程序
	广义上shell包括：GUI:Gnome，KDE，Xface
					 CLI:sh，csh（支持编程，编程风格接近C语言），ksh，bash，tcsh，zsh
					进程是一个程序的副本，是程序执行的实例。
					同时登陆多个用户，有一个shell程序，有多个shell进程。每个进程认为当前系统只有内核和当前进程，意识不到其他进程的存在。
					同一个用户可以登陆多次。
					系统识别进程靠进程号，进程可以同名。
	用户工作环境：
	对bash而言：# 管理员
				$ 普通用户
	shell，子shell（shell 中可以再打开shell）
	子shell和父shell彼此无法意识到对方的存在，对某一个shell的环境设置对另一个shell的环境没有关联	
	bash特性：
		1.命令历史、命令补全
		2.管道、重定向

		3.命令行别名
				alias CMDALIAS='COMMAND [options][arguments]'
				在shell中定义的别名，只能在当前shell进程起作用。对其他shell讲无效。eg:alias cls=clear
			撤销别名：unalias CMDALIAS     eg:unalias cls(别名)
				\CMD  别名为某些命令加选项时，使用命令本身

			命令替换：$(CMMAND) 或者 反引号(波浪线上的引号)`COMMAND`
				把命令中某个子命令替换为其执行结果的过程
				echo "the cuttent directory is /root."
				echo "the current directory is $(pwd)."	
				例子:创建一个文件，文件名为当前时间：file-2019-02-22-12-10-50.txt
								     touch ./file-$(date +%F-%H-%M-%S).txt
									 touch 'a b' 文件名包含了空格，实际最好不要包含
				bash支持的引号：
						``：变量替换
						""：弱引用，可以实现变量替换
						''：强引用，不完成变量替换
		4.命令行编辑
		5.命令行展开
		6.文件名通配:globbing
			*:匹配任意长度的任意字符  eg: ls a*:显示a开通后跟任意字符的文件
			?:匹配任意单个字符
			[]:匹配指定范围内的任意单个字符  eg:[abc],[a-m],[a-z],[0-9],[a-zA-Z].[0-9a-zA-Z]
			[^]:匹配指定范围外的任意单个字符 eg:[^0-9] 非数字	
			[:space:]:空白字符
			[:punct:]:标点符号
			[:lower:]:小写字母
			[:upper:]:大写字母
			[:alpha:]:大小写字母
			[:digit:]:数字
			[:alnum:]:数字和大小写字母
			#man 7 glob  查看相关内容
###### 练习：

	1.显示所有以a或者m开头的文件:
	ls [am]*
	2.显示所有文件名包含了数字的文件：
	ls *[0-9]*
	ls *[[:digit:]]*
	3.显示所有以数字结尾且文件名中不包含空白字符的文件：
	ls *[^[:space:]]*[[:digit:]]  此表达方式不精确，正则表达式可以解决这个问题
	4.显示文件名包含了非字母或数字的特殊符号的文件：
	ls *[^[:alnum:]]*
	
		7.支持变量
		8.支持编程
			命令编辑特性：
		
				光标跳转：
				Ctrl+A：跳到命令行行首
				Ctrl+E：跳到命令行行尾
				Ctrl+U：删除光标到命令行行首的内容
				Ctrl+K：删除光标到命令行行尾的内容
			
			命令历史：history
				bash自动记录过去使用过的命令，保存在缓冲区
				history -c ：清空命令历史
						-d 500：删除第500个历史记录
						-d 500 10：从第500个开始删除10个
						-w 保存命令历史至历史文件
				命令历史使用技巧
					!n :执行命令历史中的第n条命令
					!-n:执行命令历史中的倒数第n条命令
					!!:执行上一条命令
					!string（指定字符串）:执行命令历史中最近的以指定字符串（string）开头的命令
					!$:引用上一个命令最后一个参数
					Esc+.:引用上一个命令最后一个参数
					Alt+.:引用上一个命令最后一个参数
			命令补全：按Tab键在path环境变量下搜索补全
			路径补全：在所给的开头路径查找			
				不唯一，则两次按Tab键，显示以相应字符串开头命令
		环境变量
			PATH:命令搜索路径
			HISTSIZE:命令历史大小（变量）  redhat默认1000条（echo %HISTSIZE 查看变量HISTSIZE的大小）
			SHELL: echo $SHELL

###### 用户、组、权限：

	用户：获取资源或者服务的标识符
	用户组：同样属于标识符
	用户的容器就是组，容器关联着访问计算机资源的权限，用户组-方便指派权限
	谁发起进程，该进程就代理谁操作计算机，进程也有属主--这叫进程的：安全上下文（security context）
	
###### 文件权限：r,w,x   x:executable

	9位，每三位一组：rwxr--r--:rwx(读、写、执行)(属主)，r--(属组)，r--(其它)
	目录权限：
	r:可以对此目录执行ls列出内部所有文件；
	w:可以在此目录创建文件；
	x:可以使用cd切换进此目录，也可以使用ls -l查看内部文件详细信息
默认不应该让文件有x权限，但是目录应该有x权限
###### 各权限的二进制表示：
	000：---
	001：--x
	010：-w-
	011：-wx
	100：r--
	101：r-x
	110：rw-
	111：rwx
    数字表示权限：755：rwxr-xr-x
			  rw-r-----:640
 
标识用户：UID  /etc/passwd
标识组  ：GID  /etc/group
解析：名称解析，将用户名转换为UID，相对应数据库 /etc/passwd（用户数据库文件，用户密码在此不可见，在shadow）
				将组转换为GID，相对应数据库 	/etc/group
				
###### 影子口令：

          /ect/shadow  存放用户密码
		  /ect/gshadow 存放组密码
 
###### Linux用户类别：（红帽） 

	管理员：UID：0  内部法则改不了
	普通用户：UID: 1-65535   0给了管理员
			系统用户：1-499  专门用来运行某一类服务进程、后台进程，限制其不能登录系统
			一般用户：500-60000
###### Linux用户组类别：

	管理员组：
	普通组：
		系统组：
		一般组：
			·或者这样分类·
			私有组：创建用户时，若没有给用户指定组，则系统会为其分配一个 私有组。
			基本组：用户的默认组，每个用户都有一个基本组，只有该用户的组
			附加组（额外组）：
进程：tom（属主） tom（属组）
对象：rwxrw-r-- jarry tom a.txt   该进程以rw-权限访问a.txt
	
	eg:tom:ls
	   rwxr-xr-x root root /bin/ls
	   tom 以其它用户（r-x）的身份访问ls命令，ls相关的进程启动后其身份决定于tom（发起人）。

###### /etc/passwd中字段：

	account：登录名
	password:
	UID：用户ID
	GID：基本组ID
	comment：用户注释信息
	HOME DIR:家目录
	SHELL:用户默认shell
    /etc/shadow	中字段：
	account：登录名
	encrypted password:加密的密码
					   加密方法：对称加密，加密和解密使用同一个密码	
								 公钥加密，每个密码成对出现，一个为公钥（public key），一个为私钥（secret key）
										   公钥加密只能使用对应的私钥解密，公钥加密安全性比私钥加密高，速度慢的多。
								 单向加密，也叫散列加密，用来提取数据唯一的特征码（如指纹）。做数据完整性校验，非可逆。
								 单向加密特性：1.雪崩效应：输入微小变化，特征值就变化巨大，防破解。蝴蝶效应：初始条件的微小变化能引起结果的巨大变化。
								               2.定长输出		
											MD5(message digest)：128为定长输出，版本5
											SHA1(SECURE Hash Algorithm)，160位的定长输出
											SHA256，SHA512军用级加密算法
	增加一个用户：命令：useradd 用户名    增加的用户默认配置在/etc/default/useradd
	修改该用户密码：命令：passwd 用户名   
	手动添加一个组：groupadd 组名         增加的组配置文件列表/etc/group

###### 用户管理的命令：

	useradd,userdel,usermod,passwd,chsh,chfn,finger,id,chage(改变用户外围属性)
	
	id：查看用户账号属性信息
		-u -g -G -n 等
	finger：查看用户账户信息
	
	useradd [options] USERNAME
			-u UID(>=500)
			-g GID(指定 基本组)
			-G GID,...附加组可以有多个，用逗号隔开
			-c "COMMENT" 指定注释信息
			-d /path/to/somedirectory 指定其家目录
			-s /bin/bash (指定shell路径)
				/etc/shells:指定了当前系统可用的安全shell
			-m -k  为新增用户创建家目录，并将/etc/skel文件拷贝到家目录，该文件为用户
					shell环境配置文件
			-r  添加一个系统用户，不允许登录系统，没有家目录	////////////////	
			-M  不创建家目录	
			/etc/login.defs 规定创建用户时所要做的动作的配置文件
	
	手动添加一个用户可以分别编辑三个文件，在每个文件中增加一行：
															/etc/passwd
															/etc/group
															/etc/shadow
	
	userdel：userdel [options] USERNAME
			-r 删除用户的同时删除家目录，默认不删除			
			+
			..
	
###### 修改用户账户属性：

	usermod	
			-u UID USERNAME 
			-g GUI GROUPNAME
			-a -G GROUPNAME 指定多的附加组，使用-a表示不覆盖之前的附加组
			-c 指定注释信息
			-d 指定新的家目录，如果此前用户登录过创建了很多文件，则之前的目录无法访问了
			-d -m 指定新的家目录的同时，移动之前的文件至新的家目录
			-s 指定新的shell
			-l 改loginname
			-L 锁定账号
			-U 解锁账号			
			更多信息 man usermode
	chsh USERNAME 修改改默认shell
	chfn USERNAME 修改注释信息
	
密码管理：
	
	passwd [USERNAME]
			--stdin 从标准输入接受密码  ehco "redhat" | passwd --stdin user3
			-l 锁定账号密码
			-u 解锁账号密码
			-d 删除密码 默认redhat不允许无密码账号登录系统
	pwck  检查用户账号完整性
	
			
				
###### 组管理命令：

	groupadd,groupdel,groupmod,gpasswd
	groupadd 
		-g GID 指定GID
		-r 添加系统组
		
	groupmod 
		-g GIU 修改GID
		-n 修改组名
	groupdel [GROUPNAME] 删除组
	
	gpasswd [GROUPNAME] 为组设定密码
	
	newgrp GROUPNAME 登录到新组，使用exit退出
	
	chage(change age):改变账号的变动修改信息
		-d 最近一次的修改时间
		-E 过期时间
		-I 非活动时间
		-m 最短使用期限
		-M 最长使用期限
		-W 警告时间
	cal 查看日历
	
	
	
###### 用户、组练习题：

	1.创建一个用户mandriva，其id号为2002，基本组为distro（id 2003），附加组为linux；
	#groupadd -g 2003 distro
	#groupadd linux
	#useradd -u 2002 -g distro -G linux mandriva
	
	2.创建一个用户fedora，其全名为Fadora Community，默认shell为tcsh；
	#useradd -c "Fadora Community" -s /bin/tcsh fadora
	
	3.修改mandriva的id号为4004，基本组为linux，附加组为distro和fadora；
	#usermod -u 4004 -g linux -G dostro,fadora mandriva
	
	4.给fadora加密码，并且设置其密码最短使用期限是2天，最长为50天；
	#passwd -n 2 -x 50 fedora
	
	5.将mandriva的默认shell改为/bin/bash；
	#usermod -s /bin/bash mandriva
	#chsh -s /bin/bash mandriva
	
	6.添加系统用户hbase，且不允许其登录系统
	#useradd -r -s /sbin/nologin hbase



权限管理：chown,chgrp,chmod,umask,
	r
	w 			
	x 
	
###### 三类用户:
		
		chgrp 改变属组:	
		chgrp GROUPNAME file1,...	
			-R 递归修改，修改目录及内部文件的属组
			--reference=/path/to/somefile file,...(将file,...的属组设置为/path/to/somefile的属组)
		
		chmod 修改文件权限：
		1.chmod修改三类用户权限：
		chmod MODE file,...
			-R
			-reference 
	    rwxr-xr--：chmod 750 /tmp/asd  (若为75，则默认075，一定要给够3位数)
		
		2.修改某类用户或某些类权限
		u,g,o,a（all）
		chmod 用户类别=MODE file,...  #MODE=rwx,r-x,--x,...
		chmod g=r,o=r file 相当于 chmod go=r file
		chmod go=rw,u=     #=号后面不给，改为没有任何权限
		
		3.修改某类用户的某位或某些位
		chmod u+|-(r/w/x) file,...  eg：chmod u-x asd  表示将属主的执行权限去除
									eg：chmod u+x asd  表示将属主的执行权限添加
###### 练习：
	1.新建一个没有家目录的用户openstack；
	#useradd -M openstack
	
	2.复制/etc/skel为/home/openstack;
	#cp -r /etc/skel /home/openstack
	
	3.改变/home/openstack及其内部的属主属组均为openstack；
	#chown -R openstack:openstack /home/openstack
	
	4./home/openstack及其内部文件，属组和其它用户没有任何访问权限
	#chmod go= /home/openstack
	
	
	使用 su - openstack 查看更改是否成功	
	
###### 练习：

	1.手动添加用户hive，基本组为hive（500），附加组为mygroup
	分别编辑：/etc/group
			  /etc/passwd
			  /etc/shadow
			  chmod 
			  chown


###### umask :遮罩码		
  
	用户创建文件目录时计算默认权限使用的umask ，管理员umask=022，普通用户umask=002
	创建文件后的权限=666-umask   ，文件默认不允许有执行权限，如果创建文件时使用
									umask算出有执行权限，则权限数值自动加1。
	创建目录后的权限=777-umask	
	
###### 站在用户角度shell类型：

	1.登录式shell
	正常通过某终端登录：su - USERNAME; su -1 USERNAME;
	2.非登录式shell
	su USERNAME	
	图形终端中打开的命令窗口
	自动执行的shell脚本


###### bash 的配置文件：

	全局配置
	/etc/prfile,/etc/profile.d/*.sh,/etc/bashrc
	编辑以上任何一个文件内容，对所有用户生效
	个人配置
	~/.bash_profile,~/.bashrc	
	prfile类的文件作用：
			设定环境变量
			运行命令或者脚本：登陆前的准备工作
	bashrc类的文件作用：
			设定本地变量
			定义命令别名

###### 登陆式shell如何读取配置文件？
读取顺序：
/etc/prfile --> /etc/profile.d/*.sh --> ~/.bash_profile --> ~/.bashrc/ --> etc/bashrc  

###### 非登录式shell如何读取配置文件？
读取顺序：
~/.bashrc/ --> etc/bashrc --> /etc/profile.d/*.sh
	
bash.脚本解释器

	
###### 管道和重定向：> < >> << 	|

2019.03.07 练习：

	1.显示一个文件的行数，不显示其它信息：
	wc -l /etc/passwd
	wc -l /etc/passwd | cut -d'' -f1
	
	2.统计/usr/bin/目录下的文件个数：
	ls /usr/bin | wc -l 
	
	3.取出当前系统上所有用户的shell，要求：每个shell只显示一次，按顺序显示
	cut -d: -f7 /etc/passwd | sort -u
	
	4.如何显示var/log目录下的每个文件类型
	file /var/log `ls /var/log`
	
	5.取出/etc/inittab文件的第六行
	head -6 /etc/inittab | tail -1 #先取前6行再取最后一行，就是第6行
	
	6.取出/etc/passwd文件中倒数第9个用户的用户名和shell，显示在屏幕并保存至/tmp/users
	tail -9 /etc/passwd | head -1 | cut -d: -f1,7 | tee /tmp/users 
	
	7.显示/etc目录下所有以pa开头的文件，统计个数
	ls -d /etc/pa* | wc -l
	
	8.不使用文本编辑器，将alias cls=clear 一行内容添加至当前用户名的.bashrc文件中
	echo "alias cls=clear" >> ~/.bashrc


文本查找的需要：

	grep，egrep，fgrep  
		grep ：根据模式，搜索文本，并将符合模式的文本行显示出来。
	Pattern：文本字符和正则表达式的元字符组合而成的匹配条件:''中的内容
		grep [OPTIOND] PATTERN [FILES...]


#### 正则表达式：大多数文本处理工具都支持正则表达式，正则表达式是使计算变得智能化的重要途径，也是重要手段
		基本正则表达式：Basic REGEXP
		.:
		[]:
		[^]:
	次数：
		*:其前0次1次任意次
		\?:0或1次，可有可无
		\{m,n\}:至少m次，至多n次：\{0,无穷大\}
	锚定：
		^:锚定行首：^
		$:锚定行尾：$
		\<:锚定词首：\<,\b
		\>:锚定词尾：\>,\b
	分组与引用：
		\(\):
		\1,\2,\3,...
		
	grep :使用基本正则表达式定义的模式来过滤文本的命令：
		-i:忽略字符大小写
		-v:反向搜索，不显示模式匹配匹配到的字符，显示未匹配到的字符
		-o:只显示匹配到的字符串
		--color 显示颜色
		-E 使用扩展正则表达式
		-A n：（after）当某一行被grep所指定的模式匹配到以后，不但显示该行还会显示之后的n行 
		-B n：（before）当某一行被grep所指定的模式匹配到以后，不但显示该行还会显示之前的n行 
		-C n：（context）当某一行被grep所指定的模式匹配到以后，不但显示该行还会显示前后的各n行 
		

	位置锚定
	锚定行首：^  其后面的任意字符必须在行首出现
	锚定行尾：$  其前面的任意字符必须在行尾出现
	空白行：^$  用于找出文件中空白行
	锚定词首：\<(\b):其后面的任意字符必须作为单词首部出现
	锚定词尾：\>(\b):其前面的任意字符必须作为单词的尾部出现
	eg:\<root\>  在整个文件中搜索root这个词
	
	分组
	\(\)：
	eg:\(ab\)* :ab这个整体可以出现0次1次任意次
	后向引用
	\1:引用第一个左括号以及与之对应的右括号所包括的所有内容 
	grep '\(l..e\).*\1' test1.txt
	\2:
	
#### 扩展正则表达式：Extended REGEXP	
	字符匹配：
		和基本正则表达式相同：.,[],[^],...
		
	次数匹配：
	*:
	?:0或1次，可有可无
	+:相当于\{1,\}，匹配其前面的字符至少一次
	{m,n}:至少m次，至多n次：\{0,无穷大\},不再加\
	
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
grep -E '                                                                                                                                                                                                                                                                                                                                                                                           ' 
或egrep ''	
	
grep,egrep,fgrep
fgrep:fast,不支持正则表达式，所以比较快



###### shell脚本编程：

编译器，解释器

编程语言：
	机器语言、汇编语言、高级语言
	
	高级语言：
		静态语言：编译型语言（C、C++、JAVA、C#）
			强类型（变量）语言
			关键字：能够被编译器直接转换为二进制机器代码
			
		动态语言：解释型语言（PHP,ASP.NET,SHELL,Python,perl）执行特性：on the fly
			通常是弱类型语言
			不需要转换为二进制机器代码，运行时逐句转换；边解释边执行
			shell脚本的运行需要bash作为解释器

###### 编程模型：

	面向对象
	适合于开发大型运用程序
	
	面向过程
	linux内核为面向过程的C开发的
面向对象和面向过程没有好坏之分，每种语言都有适用的场景

		shell脚本面向过程
		JAVA完全面向对象
		Python完全面向对象
		Perl面向过程和面向对象特性
		C++面向过程和面向对象特性
	

编程能力：
	脚本编程
	
	变量：内存空间
	内存：编址的存储单元
	进程：程序运行起来叫进程
	变量：存储的数值不一样，分配的空间不一样
		10：存储为字符，16位，一个字符8位
		10：存储为数值1010,4位（占用8位，计算机最小存储单位，字节，为8位）
	变量类型：（事先确定数据的存储格式和长度）	
			字符
			数值
				整型
				浮点型：如11.23可以存储为：1.123*10^1或者0.1123*10^2
						如存储2013/10/10：存储为字符64位
						存储为数值：1970-2013有一万多天，使用24位可存储下
	真、假数据类型bool：
			逻辑：1+1>2
	逻辑运算：与、或、非、异或
	
	shell：弱类型编程语言
	强类型：变量在使用前，必须事先声明，甚至还需要初始化；
	弱类型：变量用时声明（拿来直接用），甚至不需要区分类型
	
	11+c=?
	隐式转换
	显式转换
	
	NULL:空，什么都没有
		0不是空
	
	变量赋值：VAR_NAME=VALUE	填变量代表的存储空间
	
###### 对bash来说：变量类型有：

	环境变量
	本地变量（局部变量）
	位置变量
	特殊变量（bash内置，保存某些特殊数据的变量，也有人称为系统变量）

**本地变量**：声明 VARNAME=VALUE 整个bash进程可以使用
	bash ：bash进程的变量，shell中直接声明：NAME=Jerry
											echo $NAME
	不同shell（子shell父shell）中声明的变量互不相关

**局部变量**：声明 local VARNAME=VALUE 对当前代码段有用

**环境变量**： 声明 export VARNAME=VALUE 作用域：整个shell进程及子进程可以使用
				'导出'

脚本在执行时会启动一个子shell进程：
	命令行中启动的脚本会继承当前shell环境变量
	系统自动执行的脚本（非命令启动）就需要自我定义需要的环境变量

**位置变量**：
		$1,$2,...

**特殊变量**：
		$?：上一个命令执行状态返回值
		程序执行，可能返回两类返回值：
			程序执行结果
			程序状态返回代码（0-255）
				0：执行正确
				1-255：执行错误
				一般：1,2,127系统预留
				
输出重定向：
\>
\>>
2>
2>>
&>

**/dev/null**:设备，软件模拟的设备，软设备；又叫 bit bucket，给什么吃什么，**数据黑洞**。
ls /etc/passwd &> /dev/null
同时重定向，命令行无输出，echo $? 输出：0
			
**撤销变量：unset VARNAME	**		

**查看当前shell中的所有变量：
		set
查看当前shell中的环境变量：
		printenv
		env
		export**
给字符串类型的变量赋值：shell默认全是字符串型
export PATH=$PATH:/home/stevenux   
	$PATH:引用原来的PATH变量
	：   ：新增内容分号隔开	
	
#本地变量：声明        VARNAME=VALUE 作用域：整个shell进程可以使用
#局部变量：声明 local  VARNAME=VALUE 作用域：对当前代码段有用
#环境变量：声明 export VARNAME=VALUE 作用域：当前整个shell进程及子进程可以使用，于其他登陆的shell无关
#环境变量：也可以这样声明：
 **VARNAME=VALUE**
 **export VARNAME**

引用变量：**${VARNAME}**,括号可以省略,必须加花括号的情况：
			ANIMAL=Dog
			echo "There are some ${ANIMAL}s." //弱引用，可以实现变量替换
		输出：There are some Dogs.
		**不加花括号，系统认为ANIMALs是变量**
			echo 'There are some ${ANIMAL}s.' //强引用，不完成变量替换
			输出：There are some ${ANIMAL}s.  


**脚本**：命令的堆砌，按照实际需要，结合命令流程控制机制实现的源程序
		**写好的.sh脚本为二进制ASCII码文件，linux内核只识别ELF(可执行可连接文件)文件**
		**让内核启动脚本解释器来执行**
			**shebang：魔数**
		**#!/bin/bash  第一行必须以改内容开始**
			**以#开头为注释行**
			
			




		
	
	
	
	
	
	
	
作业：
	描述GPL,BSD,Apache三个开源协定的体联系及区别。
	如何获取linux当前最新版本号？
	www.kernel.org
	列出你所了解的了linux发行版，说明其跟linux内核的关系？
	linux：仅提供内核，以源代码的形式向外提供 发行商：提供能够直接安装的系统（光盘，U盘）
	发行商：Fedora,Redhat(CentOS),SUSE(桌面UI最好),Debian（Ubuntu，Mint）
	 Gentoo：给用户自己编译相关内容的自由
	 LFS(Linux From Scratch)：从头开始下载各种软件源代码，编译，拼凑为一个完整意义上的系统













