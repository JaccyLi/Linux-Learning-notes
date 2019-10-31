#

> 1.编写shell脚本对192.168.2.0/24网段主机root密码进行修改(原密码123456),要
求每台主机root密码不一样。

```bash
#!/bin/bash
#
#*******************************************************************************
#Author:            steveli
#QQ:                1049103823
#Data:              2019-10-31
#FileName:          change_host_root_passwd.sh
#URL:               https://blog.csdn.net/YouOops
#Description:       change_host_root_passwd.sh
#Copyright (C):     2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#
#NET="192.168.2"
NET="172.20.3"
ORIGINAL_PASSWD="123456"
for ((i=0 ; i < 256 ; i++)); do
if [[ $i -lt 10 ]]; then
    NEW_PASSWD="11100$i"
elif [[ $i -lt 100 ]]; then
    NEW_PASSWD="1110$i"
else
    NEW_PASSWD="111$i"
fi
#NEW_PASSWD="666666"
expect <<EOF
set timeout 20
spawn ssh root@${NET}.$i
expect {
"yes/no"   { send "yes\n";exp_continue }
"password" { send "$ORIGINAL_PASSWD\n" }
}
expect "]#" { send "echo $NEW_PASSWD | passwd --stdin root\n" }
expect "]#" { send "exit\n" }
expect eof
EOF
done
```

> 2.编写shell脚本测试192.168.1.0、/24整个网段哪些主机是开机的哪些主机是关机的。

````bash
#!/bin/bash
#
#*******************************************************************************
#Author:            steveli
#QQ:                1049103823
#Data:              2019-10-28
#FileName:          ping_specific_network.sh
#URL:               https://blog.csdn.net/YouOops
#Description:       ping_specific_network.sh
#Copyright (C):     2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#
. /etc/init.d/functions
# success
# failure
# passed
# warning
NET="192.168.1"
for ((i=0 ; i < 256 ; i++)); do
        if ping -W1 -c1 ${NET}.${i} &> /dev/null ; then
            echo "Host ${NET}.$i is UP. `success`"
        else
            echo "Host ${NET}.$i is DOWN. `warning`"
        fi  
done
```
