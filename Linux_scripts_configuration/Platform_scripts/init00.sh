#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-12
#FileName:		    reset00.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		reset00.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
RED=31
GREEN=32
YELLOW=33
COLOR_RED="\e[1;${RED}m"
COLOR_GREEN="\e[1;${GREEN}m"
COLOR_YELLOW="\e[1;${YELLOW}m"
COLOR_END="\e[0m"

VIMRC=~/.vimrc
BASHRC=~/.bashrc
PROMPT_PATH=/etc/profile.d/
HOSTNAME=stevenux
HOSTNAME_PATH=/etc/hostname
HOSTS_PATH=/etc/hosts

. /etc/init.d/functions
#success
#failure
#passed
#warning



#1.Prompt configuration
cd $PROMPT_PATH
echo "1.正在改变提示符样式..."
sleep 1
echo -e "自定义的PS1在:/etc/profile.d/env.sh"
if [ ! -e ${PROMPT_PATH}/env.sh ]; then
touch env.sh
cat >> env.sh <<EOF
#!/bin/bash
PS1="\[\e[37;40m\][\[\e[32;40m\]\u\[\e[37;40m\]@\h \[\e[36;40m\]\w\[\e[0m\]]\#"
EOF
fi

. /etc/profile.d/env.sh
echo -e "第一项，提示符自定义OK`success`"
echo 


#2.VIM style configuration
echo "2.自定义VIM样式..."
sleep 1
echo -e "更改相关的属性请查看自定义的VIM属性:~/.vimrc"

if [ ! -f $VIMRC ];then
touch $VIMRC
cat >> $VIMRC <<EOF
set number
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab 
set ignorecase
set cursorline
set autoindent
autocmd BufNewFile *.sh exec ":call SetTitle()"
func SetTitle()
    if expand("%:e") == 'sh'
        call setline(1,"#!/bin/bash")
        call setline(2,"#")
        call setline(3,"#*******************************************************************************")
        call setline(4,"#Author:            steveli")
        call setline(5,"#QQ:                1049103823")
        call setline(6,"#Data:              ".strftime("%Y-%m-%d"))
        call setline(7,"#FileName:          ".expand("%"))
        call setline(8,"#URL:               https://blog.csdn.net/YouOops")
        call setline(9,"#Description:       ".expand("%"))
        call setline(10,"#Copyright (C):        ".strftime("%Y")." All rights reserved")
        call setline(11,"#*******************************************************************************")
        call setline(12,"#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)")
        call setline(13,"#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)")
        call setline(14,"#*******************************************************************************")
        call setline(15,"#")
        call setline(16,"")
        endif
endfunc
autocmd BufNewFile * normal G
EOF
fi
. $VIMRC &> /dev/null
sleep 0.5
echo -e "第二项，VIM自定义OK`success`"
echo


#3.BASH style configuration.
echo "3.自定义bash属性..."
echo "命令别名请查看:~/.bashrc "
sleep 1

if [ -e $BASHRC ]; then
cat >> $BASHRC <<EOF
# .bashrc

# User specific aliases and functions #
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls -l'
alias la='ls -a'
alias lh='ls -lh'
alias ld='ls -ld'
alias cc='clear'
alias lt='ls -X'
alias netstat='netstat -ntupa'
alias route='route -n'
alias arp='arp -n'
alias ipr='ip route'
alias ipl='ip link'
alias cdnet='cd /etc/sysconfig/network-scripts'
alias bashn='bash -n'
alias bashx='bash -x'
alias freeh='free -h'
alias yy='yum install -y'
alias ee='echo $?'
alias re='cat /etc/redhat-release'
alias scandisk="echo '- - -' > /sys/class/scsi_host/host2/scan ; echo '- - -' > /sys/class/scsi_host/host0/scan"
alias cdb='cd -'
alias cdp='cd ..'
alias chmodx='chmod +x'
alias dus='du -sh'
alias freeh='free -wth'
# alias rm='rm -i'
# User specific aliases and functions #

######<-- rm command script alias -->#####
alias rm='~/.mv.sh'                                                                                                                                                                              
######<-- rm command script alias -->#####

######<-- edit network_configuration scripts -->######
V=`cat /etc/redhat-release | grep -o "[0-9]\+" | cut -d. -f1 | head -n1`
NET0=iifconfig | grep -o "ens[0-9]\+" | cut -ds -f2 | head -n1 
NET1=iifconfig | grep -o "ens[0-9]\+" | cut -ds -f2 | head -n2 | tail -n1 
if [ $V = 7 ]; then
alias    editnet='vim /etc/sysconfig/network-scripts/ifcfg-ens33'
elif [ $V = 8 ]; then
alias    editnet0='vim /etc/sysconfig/network-scripts/ifcfg-ens160'
alias    editnet1='vim /etc/sysconfig/network-scripts/ifcfg-ens192'
fi
######<-- edit network_configuration scripts -->######


# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
EOF
else
    touch $BASHRC
cat >> $BASHRC <<EOF
# .bashrc

# User specific aliases and functions #
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls -l'
alias la='ls -a'
alias lh='ls -lh'
alias ld='ls -ld'
alias cc='clear'
alias lt='ls -X'
alias netstat='netstat -ntupa'
alias route='route -n'
alias arp='arp -n'
alias ipr='ip route'
alias ipl='ip link'
alias cdnet='cd /etc/sysconfig/network-scripts'
alias bashn='bash -n'
alias bashx='bash -x'
alias freeh='free -h'
alias yy='yum install -y'
alias ee='echo $?'
alias re='cat /etc/redhat-release'
alias scandisk="echo '- - -' > /sys/class/scsi_host/host2/scan ; echo '- - -' > /sys/class/scsi_host/host0/scan"
alias cdb='cd -'
alias cdp='cd ..'
alias chmodx='chmod +x'
alias dus='du -sh'
alias freeh='free -wth'
# alias rm='rm -i'
# User specific aliases and functions #

######<-- rm command script alias -->#####
alias rm='~/.mv.sh'                                                                                                                                                                              
######<-- rm command script alias -->#####

######<-- edit network_configuration scripts -->######
V=`cat /etc/redhat-release | grep -o "[0-9]\+" | cut -d. -f1 | head -n1`
NET0=iifconfig | grep -o "ens[0-9]\+" | cut -ds -f2 | head -n1 
NET1=iifconfig | grep -o "ens[0-9]\+" | cut -ds -f2 | head -n2 | tail -n1 
if [ $V = 7 ]; then
alias    editnet='vim /etc/sysconfig/network-scripts/ifcfg-ens33'
elif [ $V = 8 ]; then
alias    editnet0='vim /etc/sysconfig/network-scripts/ifcfg-ens160'
alias    editnet1='vim /etc/sysconfig/network-scripts/ifcfg-ens192'
fi
######<-- edit network_configuration scripts -->######


# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
EOF
. $BASHRC &> /dev/null
sleep 0.5
echo -e "第三项，VIM自定义OK`success`"
echo
fi


#4,5,6 From Jibill Chen:Contact him:http://www.jibiao.work
#CD_NAME=$(lsblk | grep 'sr[0-9]'|head -1 | cut -c 1,2,3)
#[ $(df | grep 'sr' | wc -l) -ge 1 ] && CD_MOUNT_POINT=$(df |sed -nr '/dev\/sr/s@^/dev.*% @@p') || { mount /dev/$CD_NAME /mnt &> /dev/null ; CD_MOUNT_POINT='/mnt';}
echo "4.设置CD为yum源..."
mkdir -p /mnt/cdrom &> /dev/null
CD_MOUNT_POINT="/mnt/cdrom"
umount /dev/sr0 &> /dev/null
mount /dev/sr0 $CD_MOUNT_POINT &> /dev/null
rm -f /etc/yum.repos.d/*.repo &> /dev/null
cat > /etc/yum.repos.d/cdrom.repo << EOF
[cdrom]
name=cdrom
baseurl=file://${CD_MOUNT_POINT}
        https://mirrors.aliyun.com/epel/7/x86_64/
enabled=1
gpgcheck=0
EOF
if [ $? -eq 0 ]; then
   sleep 0.5
    echo -e "${CO_GREEN}第四项，成功设置CD为yum源^_^`success`${LOR}" 
else
    echo -e "${CO_RED}第四项，设置CD为yum源失败:(`failure`${LOR}"
fi
sleep 1

#5.Install tree screen vim bzip2  
echo "5.开始安装一些基础软件..."
yum clean all &> /dev/null
yum repolist &> /dev/null
yum -y install chrony  &> /dev/null
[ $? -eq 0 ] && echo -e "${CO_GREEN}成功安装chrony`success`${LOR}" || echo -e "${CO_RED}chrony安装失败`failure`${LOR}"
yum -y install wget tree &> /dev/null
[ $? -eq 0 ] && echo -e "${CO_GREEN}成功安装wget,tree`success`${LOR}" || echo -e "${CO_RED}wget,tree安装失败`failure`${LOR}"
yum -y install screen net-tools &> /dev/null
[ $? -eq 0 ] && echo -e "${CO_GREEN}成功安装screen net-tools `success`${LOR}" || echo -e "${CO_RED}screen net-tools安装失败`failure`${LOR}"
yum -y install  vim bzip2 &> /dev/null
[ $? -eq 0 ] && echo -e "${CO_GREEN}成功安装vim,bzip2`success`${LOR}" || echo -e "${CO_RED}vim,bzip2安装失败`failure`${LOR}"

#6.Disable iptables and firewalld
#
echo "6,关闭防火墙..."
systemctl stop firewalld &> /dev/null
[ $? -ne 0 ] && echo "${CO_RED}第六项，关闭防火墙失败`failure`${LOR}" 
systemctl disable firewalld &> /dev/null
[ $? -ne 0 ] && echo "${CO_RED}disable firewalld fail${LOR}"
iptables -F &> /dev/null
[ $? -ne 0 ] && echo "${CO_RED}shutdown iptables fail${LOR}"
echo "第七项,最后一项，失能selinux..."
sed -r -i 's#(^SELINUX=)(.*$)#\1disabled#' /etc/selinux/config &> /dev/null
[ $? -ne 0 ] && echo "${CO_RED}失能selinux失败`failure`${LOR}"

echo "重启..."
reboot
