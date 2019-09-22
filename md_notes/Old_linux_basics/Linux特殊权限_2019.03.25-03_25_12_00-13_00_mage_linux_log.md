@[TOC](Linux特殊权限)
#### 三个特殊权限
##### SUID
如果某程序文件拥有SUID权限，那么：
运行该程序时，相应进程的属主是该程序文件自身的属主，而不是启动者；

###### 增加SUID:chmod u+s FILE
###### 	去掉SUID:chmod u-s FILE
#如果FILE本身原来有执行权限，SUID显示为小写s；如果FILE本身原来没有执行权限，SUID显示为大写S；
**-rwxr-xr-x  -->  -rwsr-xr-x 
-rw-r-xr-x  -->  -rwSr-xr-x** 

##### SGID
如果某程序文件拥有SGID权限，那么：
运行该程序时，相应进程的属组是该程序文件自身的属组，而不是启动者的属组；
###### 增加SGID:chmod g+s FILE  
###### 去掉SGID:chmod g-s FILE  
**-rwxr-xr-x  -->  -rwxr-gr-x 
-rwx-r-xr-x  -->  -rwxr-Gr-x** 
##### Sticky
表示在一个公共目录，每个用户都可以创建文件，删除自己的文件，但是不能删除别人创建的文件；
###### 增加Sticky:chmod o+t
###### 去掉Sticky:chmod o+t
**-rwxr-xr-x  -->  -rwxr-xr-t 
-rwx-r-xr-x  -->  -rwxr-xr-T**

#### 三个特殊权限对应的二进制表示
000——111
SUID:SGIU:Sticky
5 ——> 101:有SUID和Sticky权限位，无SGID权限位；

#### umask
回忆：umask 0022
第一位就是特殊权限十进制值

