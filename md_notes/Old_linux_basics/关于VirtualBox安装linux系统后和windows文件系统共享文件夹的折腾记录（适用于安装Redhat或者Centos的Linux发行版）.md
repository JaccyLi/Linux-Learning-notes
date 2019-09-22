@[TOC](VirtualBox和windows文件系统共享文件夹)
## 背景
最近由于学习shell编程，需要在virtualbox安装的linux和windows系统中共享文件夹，以便把在linux下的脚本直接搬到博客中。于是在网上收集各种共享教程，现已配置成功，总结一下如何在VirtualBox下的Linux环境配置共享文件夹。
### 系统环境
1.本次使用的VBox 版本为Version 6.0.0 r127566 （Qt 5.6.2 ）;
2.Linux系统版本：Linux version 3.10.0-957.10.1.el7.x86_64 （Red Hat 4.8.5-36）
3.Windows 7 enterprise Service pack 1

### 配置涉及知识讲解
1.在VirtualBox上安装好Linux后，实际上还有部分非常好用的增强功能未激活，这些功能都是内建于VirtualBox的，要在客户机上使用这些功能，需要在客户机安装名叫VBoxGuestAdditions.iso的镜像内的扩展程序，该镜像默认位于VBox安装目录的根目录；
（名词解释：客户机系统guest OS，即是在VirtualBox安装的操作系统；主机系统host OS ，即是我们日常使用的安装在自己物理主机上的操作系统，在这里是我的window 7）
关于客户机安装扩展程序的英文说明，可移步link：https://www.makeuseof.com/tag/virtualbox-guest-additions-what-they-are-and-how-to-install-them/
### 扩展程序安装后可使用的几种增强功能
#### Automatic Resizing 自动调整窗口大小
实现该功能的大致原理是：VBoxGuestAdditions扩展程序通过检测虚拟机VBox的窗口大小，告知客户机系统guest OS具体的窗口大小，如同让客户机认为自己连接到一个和VBox的窗口大小一样大的显示器一样。
#### Shared Clipboard 共享粘贴板
可以实现双向拷贝文件，无论在哪个操作系统（客户机操作系统还是主机操作系统）拷贝的文件（文本文档，图片等）都可以互相粘贴。
#### Drag and Drop 使用拖拽和放开来拷贝粘贴文件
在一个系统中（host OS）拖拽文件到另一个系统(guest OS)中实现拷贝粘贴，or vice versa.
#### Seamless Mode 无缝模式
允许虚拟机（客户机系统）的软件桌面和主机系统桌面系统合并，看起来虚拟机的软件就像原生的主机系统内的软件一样。当然，窗口的样式还是保持客户机的样式。
#### Share folders共享文件夹 
允许在客户机系统和主机系统中共享文件夹；

### 扩展程序安装（VBoxGuestAdditions.iso）
安装扩展程序之前，确保运行一下命令：
 Federa，Redhat，Centos下：
`sudo yum install gcc g++ dkms kernel-devel`
Ubuntu 下:
`sudo apt-get install gcc g++ dkms`

==开始安装扩展程序==
**第一步**：首先将名为VBoxGuestAdditions.iso的镜像挂载在客户机系统的虚拟光驱上，操作如下：
![挂载客户机系统扩展程序光盘](https://img-blog.csdnimg.cn/20190329103702436.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1lvdU9vcHM=,size_16,color_FFFFFF,t_70)
第4步后会让选择VBoxGuestAdditions.iso镜像地址；为VBox安装目录，我的为：`C:\Program Files\Oracle\VirtualBox`

**第二步**：进入linux（客户机系统），首先挂载VBoxGuestAdditions.iso镜像到目录
bash中键入命令：
`mkdir /mnt/cdrom`
`sudo mount -t vboxsf /mnt/cdrom`
或者
`mkdir /dev/cdrom`
`sudo mount -t vboxsf /dev/cdrom`
命令说明：mkdir /mnt/cdrom 表示在文件夹 /mnt下新建一个文件夹/cdrom （linux中文件夹以/开始）；sudo mount -t vboxsf mnt/cdrom 表示将刚刚挂载到虚拟光驱的VBoxGuestAdditions.iso挂载到刚刚新建的/cdrom文件夹下（linux中，在没有配置的情况下不会像windows一样自动读取识别挂载的光盘镜像，需要手动挂载）
**如果出现如下错误：**
`mount: can't find cdrom in /etc /fstab or /etc/mtab `
通过错误信息可知在/etc/fstab找不到要挂载的文件
	**解决方式：**
方法一：.输入命令:`mount -t iso9660 /mnt/cdrom` 其中/dev/cdrom为软连接指向的是hdc即是镜像文件的挂载盘 
这时候在输入命令：`ls -l /mnt/cdrom`  enter键显示要挂载的iso文件里的所有文件，到此成功挂载镜像 
方法二：修改/etc/fstab文件 
首先编辑文件fstab命令：`vi /etc/fstab` 在文件里追加一行内容：`/dev/cdrom   /mnt/cdrom  iso9660  defaults  0 0 `
然后再执行命令：`mkdir /mnt/cdrom`和`mount /mnt/cdrom` 
这时候在输入命令：`ls -l /mnt/cdrom`  enter键显示要挂载的iso文件里德所有文件，到此成功挂载镜像 

挂载后大致内容如下图：
![挂载virtualguestextensions内容](https://img-blog.csdnimg.cn/20190329110418602.png)
**第三步**：运行VBoxLinuxAdditions.run，在命令行键入：
`./VBoxLinuxAdditions.run `     
等待一会儿就安装完成。
==至此，扩展程序安装完成！！！==


### Share folders共享文件夹安装与配置


**第一步**：设置主机系统需要共享的文件夹，操作如下
![设置共享文件夹](https://img-blog.csdnimg.cn/20190329104242424.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1lvdU9vcHM=,size_16,color_FFFFFF,t_70)
注意到红框，Mount point 表示在客户机系统（linux）中的挂载点，填写为你想挂载的文件夹名称。勾选Make Permanent，这样你重启客户机系统后，挂载点会在同一个目录中。


**第二步**：进入linux，挂载刚刚设置的共享目录
命令：
`mkdir folder1`     folder1为linux（客户机系统）当中的文件夹
`sudo mount -t vboxsf /folder1 /folder2/ `    folder2（主机系统，对应上面图中的Folder name选项中的文件夹名称）对应linux当中的folder1文件夹
如果想方便一点就这样：将主机系统中的文件夹命名为folder1，运行下面两条命令即可：
`mkdir folder1`
`sudo mount -t vboxsf folder1/ folder1/`
在windows下放一些文件到folder1文件夹，
运行以下命令，查看共享文件夹的内容
`cd ./folder1`
`ls -l`

==自此，配置完成==

