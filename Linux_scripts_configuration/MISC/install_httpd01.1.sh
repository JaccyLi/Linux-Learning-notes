#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-14
#FileName:		    install_httpd.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		install_httpd.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

clear

. /etc/init.d/functions

if [[ ! -e /var/log/httpd ]]; then
mkdir -p /var/log/httpd
fi
if [[ ! -e $HOME/httpd ]]; then
mkdir $HOME/httpd
fi

WORKSPACE="$HOME/httpd"
LOG_FILE="/var/log/httpd"
PREFIX="/app/httpd"
SYSCONFDIR="/etc/httpd"
VERSION=`cat /etc/redhat-release | sed -nr 's/.*([0-9]+)\.[0-9]+\..*/\1/p'`
IP=`ifconfig |sed -nr 's@[^0-9]+([0-9.]+).*@\1@p' |sed -nr '/\b(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\b/p' |sed '1!d'`

prompt() {                                                                                                                            
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' ' 
    while sleep 0.1; do
        printf "%s\b" "${sp:i++%n:1}"
    done
}


if [[ $VERSION -eq 7 ]]; then
    HTTPD_DIR="httpd-2.4.25"
    HTTPD_SRC="httpd-2.4.25.tar.bz2"
    SYSCONFDIR="/etc/httpd/conf"
else
    HTTPD_DIR="httpd-2.4.41"
    HTTPD_SRC="httpd-2.4.41.tar.bz2"
fi

    cd $WORKSPACE    ##:eg:/root/httpd2
    ## 1.Install develipment tools httpd needed
    echo -e "Trying to install some dev packages..."
	prompt &
    for PKG in gcc make apr-devel apr-util-devel pcre-devel openssl-devel; do
	if ! rpm -qi $PKG &> /dev/null; then
	    yum install $PKG -y
            echo -e "Package $PKG now installed."	
	else
            echo -e "Package $PKG have installed."	
        fi
    done
    # yum install gcc make apr-devel apr-util-devel pcre-devel openssl-devel &> $LOG_FILE/dev.log
    # echo -e "Development tools installed.`success`"
	if [[ $? -eq 0 ]];then
		kill "$!" > /dev/null 2>&1 # kill the prompt
		echo -e "`success`"
	fi

    ## 2.Get source from suosuoli.cn
    echo -e "Getting $HTTPD_SRC from suosuoli.cn ..."
	prompt &
    wget http://suosuoli.cn/suo/sources/$HTTPD_SRC &> $LOG_FILE/wget.log
	if [[ $? -eq 0 ]];then
		kill "$!" > /dev/null 2>&1 # kill the prompt
		echo -e "`success`"
	fi
    tar -xf $HTTPD_SRC &> $LOG_FILE/tar.log 
    cd $WORKSPACE/$HTTPD_DIR   ##:eg:/root/httpd2/httpd-2.4.25

    ## 2.5Configure yum eource.
   

    ## 3.Configuration&&compile&&install 
		echo -e "Runing cofigure script..."
		prompt &
    ./configure --prefix=$PREFIX --sysconfdir=$SYSCONFDIR --enable-ssl &> $LOG_FILE/configure.log
		if [[ $? -eq 0 ]];then
			kill "$!" > /dev/null 2>&1  # kill the prompt
			echo -e "`success`"
		fi
    if [[ $? -eq 0 ]]; then
        	echo -e "Compiling..."
		prompt &
        make -j 2 &> $LOG_FILE/make.log
		if [[ $? -eq 0 ]];then
			kill "$!" > /dev/null 2>&1 # kill the prompt
			echo -e "`success`"
		fi
    fi
    echo -e "Installing..."
        prompt &
    make install &> $LOG_FILE/make_install.log
	if [[ $? -eq 0 ]];then
		kill "$!" >  /dev/null 2>&1 # kill the prompt
		echo -e "`success`"
	fi
    [[ "$?" -eq 0 ]] &&  \
    echo -e "$HTTPD_DIR successfully installed.`success`\n"



    ## 4.Configure PATH variable
    echo "PATH=$PREFIX/bin:$PATH" > /etc/profile.d/httpd.sh
    . /etc/profile.d/httpd.sh
    [[ $? -eq 0 ]] && echo -e "PATH variable configured.`success`"


    ## 5.Configure user&&group for apache
    if ! id apache &> /dev/null; then
	useradd -r -s /sbin/nologin apache
    fi
   # sed -nri 's#^User daemon#User apache#' $SYSCONFDIR/httpd.conf
   # sed -nri 's#^Group daemon#Group apache#' $SYSCONFDIR/httpd.conf
    [[ $? -eq 0 ]] && echo -e "user&&group configured.`success`"

    ## 6.Check if httpd2 can run properly.
    apachectl start  &> /dev/null && echo "Trying to start httpd2..." 2> $LOG_FILE/err0.log
    [[ $? -eq 0 ]] && echo -e "httpd2 is running ... `success`"

    ## 7.Verify if httpd can host the web properly.
    if rpm -qi curl &> /dev/null; then
        if curl www.baidu.com &> /dev/null; then
            curl http://$IP &> /dev/null
            if [[ $? -eq 0 ]]; then
		echo -e "Congratulatons,visit your web at \e[1;32mhttp://$IP!\e[0m`success`"
	    else 
		echo -e "Oh,no.something wrong to visit your website.`failure` \nCheck the log at:$LOG_FILE/install.log!" 2>> $LOG_FILE/err0.log
	    fi
        fi
    else
    yum install curl
    [[ $? -eq 0 ]] && curl http://$IP &> /dev/null
	if [[ $? -eq 0 ]];then 
	     echo -e "Congratulatons,visit your web at \e[1;32mhttp://$IP!\e[0m`success`" 
	else
	     echo -e "Oh,no.something wrong to visit your website. \nCheck the log at:$LOG_FILE/install.log!" 2>> $LOG_FILE/err0.log
	fi
    fi

    ## 8.Genenrate log file
    cat "$LOG_FILE/dev.log" "$LOG_FILE/wget.log" "$LOG_FILE/configure.log" "$LOG_FILE/make.log" "$LOG_FILE/make_install.log" "$LOG_FILE/err0.log" > $LOG_FILE/install.log
    [[ $? -eq 0 ]] && echo -e "Check the brief log at $LOG_FILE/install.log!`success`"
