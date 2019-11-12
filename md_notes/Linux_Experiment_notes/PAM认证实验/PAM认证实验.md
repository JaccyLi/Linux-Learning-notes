# :arrow_forward:实验：PAM认证实验

## :one:实验1.检查某用户使用的shell是否是/etc/shells文件中列有的shell，如果不是则不予登录,root也不例外

- vim /etc/shells

```py
[root@centos8 ~]#vim /etc/shells
  1 /bin/sh
  2 #/bin/bash
  3 /usr/bin/sh
  4 /usr/bin/bash
  5 /usr/bin/tmux
  6 /bin/tmux
  7 /usr/bin/zsh
  8 /bin/zsh
```

- vim /etc/pam.d/login
`auth   required    pam_shells.so`

- root将无法登录

- 取消/etc/shells第二行注释或者注释/etc/pam.d/login(auth   required    pam_shells.so),root恢复可以登录

## :two:实验2.只允许root用户在/etc/securetty列出的安全终端上登陆


## :three:

## :four:

## :five:

## :six:

## :seven:

## :eight:

## :nine:

## :keycap_ten:

## :arrow_left:exit

## :repeat:reboot
