@[TOC](Linux压缩及归档)

## 压缩格式
linux常用压缩格式：
**gz，bz2，xz，zip，.Z**
**压缩算法**：压缩算法不同，压缩比也不同
目前比较流行的三种压缩方式：
xz,bz2,gz
压缩工具及压缩后的后缀：
```1
gzip:.gz
bzip2:.bz2
xz:.xz
```
**不能压缩目录，只对文件逐个压缩，默认压缩后删除原文件。**

## gzip
```1
gzip:.gz
gzip /PATH/TO/SOMEFILE    #压缩完后会删除原文件
	-d ：解压缩（gunzip）
	-# ：1-9，指定压缩比，默认为6
gunzip：解压缩
gunzip /PATH/TO/SOMEFILE.gz  #解压缩后删除原文件
```
## zcat 查看压缩文件，本身不解压缩
```1
zcat /PATH/TO/SOMEFILE.gz
```
## bzip2
```1
bzip2比gzip有着更大压缩比，压缩后文件更小
bgzip2 /PATH/TO/SOMEFILE    #压缩完后会删除原文件
	-d ：解压缩（bunzip）
	-# ：1-9，指定压缩比，默认为6
	-k：压缩后保留原文件
bunzip2 /PATH/TO/SOMEFILE.bz2 
```
## bzcat 直接查看.bz2文件
```1
bzcat /PATH/TO/SOMEFILE.bz2 
```

## xz
```1
xz /PATH/TO/SOMEFILE    #压缩完后会删除原文件
	-d ：解压缩（unxz）
	-# ：1-9，指定压缩比，默认为6
unxz：解压缩
unxz /PATH/TO/SOMEFILE.xz #解压缩后删除原文件

```
## xzcat 直接查看.bz2文件
```1
xzcat /PATH/TO/SOMEFILE.xz
```

## zip压缩工具即能归档又能压缩
```1
压缩比不大，可以压缩目录，压缩后不删除源文件
众多系统默认支持的压缩格式
zip FILENAME.zip FILE1 FILE2 ... 
zip test.zip test/*     #将/test目录下所有文件都压缩打包为test.zip
archive:归档，并不意味着压缩，只不过zip即能归档又能压缩，压缩后不删除源文件
unzip FILENAME.zip    #解压缩
```

## tar工具只归档不压缩
```1
tar：归档工具    命令中：-可以省略
	-c：创建归档文件
	-f FILENAME.tar：指定要操作的归档文件,-f必须放在命令后面跟上归档后的文件名
eg：tar -cf tset.tar test*.txt   #把所有以test开头，.txt结尾的文件归档保存为test.tar
    -x ：展开归档文件
eg：tar -xf test.tar
    --xattrs：归档时保留文件的扩展属性信息（facl）
    -tf FILENAME.tar ：不展开归档查看归档所包含的文件,归档压缩后的文件也可以查看
    -zcf：即归档又压缩（-z调用gzip压缩） 
    -zxf：调用gzip解压缩并展开归档，此处-z选项可以省略
    -jcf：即归档又压缩（-j调用bzip2压缩） 
    -jxf：调用bzip2解压缩并展开归档，此处-j选项可以省略
    -Jcf：即归档又压缩（-J调用xz压缩） 
    -Jxf：调用xz解压缩并展开归档，此处-J选项可以省略
```
## cpio命令	
cpio命令也是一个归档工具，比tar更古老

## read命令
```1
read从命令行读取内容,bash内部命令
	-p "PROMPT" :给出提示
	-t # :给个输入延时时间
```

### 练习
写一个脚本，从键盘让用户输入几个文件，脚本能够将这些文件归档压缩成一个文件；

```shell
#!/bin/bash
#myarchive.sh
declare -i NOCOMP=9
read -p "Three files for archive:" FILE1 FILE2 FILE3
read -p "Destination:" DEST
read -p "Compress method[gzip|bzip2|xz]:" COMP

case $COMP in
gzip)
        tar -zcf ${DEST}.tar.gz $FILE1 $FILE2 $FILE3
;;
bzip2)
        tar -jcf ${DEST}.tar.gz $FILE1 $FILE2 $FILE3
;;
xz)
        tar -cf ${DEST}.tar $FILE1 $FILE2 $FILE3
        xz ${DEST}.tar
;;
*)
        echo "Unknown compress method."
        exit $NOCOMP
;;
esac
```
运行结果：
```1
[root@MiWiFi-R3A-srv ~]# ./scripts/myarchive.sh 
Three files for archive:ls.txt man.txt tar.txt
Destination:./test   
Compress method[gzip|bzip2|xz]:gzip
[root@MiWiFi-R3A-srv ~]# ls
anaconda-ks.cfg  ls.txt  ls.zip  man.txt  packages  scripts  tar.txt  test.tar.gz
[root@MiWiFi-R3A-srv ~]# tar -tf test.tar.gz 
ls.txt
man.txt
tar.txt
[root@MiWiFi-R3A-srv ~]# ls -lh
total 96K
-rw-------. 1 root root 1.4K Apr  4 07:46 anaconda-ks.cfg
-rw-r--r--. 1 root root 7.9K Apr  9 22:18 ls.txt
-rw-r--r--. 1 root root 3.2K Apr  9 22:21 ls.zip
-rw-r--r--. 1 root root  34K Apr  9 22:18 man.txt
drwxr-xr-x. 2 root root 4.0K Apr  9 21:20 packages
drwxr-xr-x. 2 root root   57 Apr  9 22:52 scripts
-rw-r--r--. 1 root root  17K Apr  9 22:53 tar.txt
-rw-r--r--. 1 root root  20K Apr  9 22:54 test.tar.gz
```

