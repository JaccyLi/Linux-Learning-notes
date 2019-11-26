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
alias rm='rm -i'
# User specific aliases and functions #

######<-- rm command script alias -->#####
#alias rm='~/.mv.sh'
######<-- rm command script alias -->#####

######<-- edit network_configuration scripts -->######
#V=`cat /etc/redhat-release | grep -o "[0-9]\+" | cut -d. -f1 | head -n1`
NET0=iifconfig | grep -o "ens[0-9]\+" | cut -ds -f2 | head -n1 
NET1=iifconfig | grep -o "ens[0-9]\+" | cut -ds -f2 | head -n2 | tail -n1 
#if [ $V = 7 ]; then
#alias    editnet='vim /etc/sysconfig/network-scripts/ifcfg-ens33'
#elif [ $V = 8 ]; then
#alias    editnet0='vim /etc/sysconfig/network-scripts/ifcfg-ens160'
#alias    editnet1='vim /etc/sysconfig/network-scripts/ifcfg-ens192'
#fi
######<-- edit network_configuration scripts -->######


# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
