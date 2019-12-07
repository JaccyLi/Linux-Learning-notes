# Trouble Shooting

- 出现以下问题?

```sh
root@ubuntu1904:~#ansible all -m shell -a 'ls'
172.20.1.87 | FAILED! => {
    "changed": false,
    "module_stderr": "Shared connection to 172.20.1.87 closed.\r\n",
    "module_stdout": "/bin/sh: /usr/bin/python: No such file or directory\r\n",
    "msg": "The module failed to execute correctly, you probably need to set the interpreter.\nSee stdout/stderr for the exact error",
    "rc": 127
}
```

- 原因是在目标主机未找到 python 程序
- 查看是有 python 的，只不过 ansible 只识别'python'，不识别'python2';创建一个名为 python 的软连接链接到 Python2 即可
- 如果没有就直接安装`yum install python -y`

```sh
[root@localhost ~]# ll /usr/bin/ | grep python
lrwxrwxrwx  1 root root          9 Oct  9 05:08 python2 -> python2.7
-rwxr-xr-x  1 root root       9264 Oct  9 05:08 python2.7
lrwxrwxrwx  1 root root         25 Dec  3 20:42 python3 -> /etc/alternatives/python3
lrwxrwxrwx  1 root root         31 Jun 22 23:20 python3.6 -> /usr/libexec/platform-python3.6
lrwxrwxrwx  1 root root         32 Jun 22 23:20 python3.6m -> /usr/libexec/platform-python3.6m
lrwxrwxrwx  1 root root         24 Dec  3 20:42 unversioned-python -> /etc/alternatives/python
[root@localhost ~]# ln -s /usr/bin/python2 /usr/bin/python
```
