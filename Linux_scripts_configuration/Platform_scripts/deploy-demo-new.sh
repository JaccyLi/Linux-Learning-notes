#!/bin/bash 
# Created by suosuoli.cn on 2020.03.15
# A script for deploy automation.
# The script can only work with ubuntu and Jenkins.
# Run it manully via root also works.

#### deploy-demo environment ####
# hostname             ip               role
# tomcat-server-node1  192.168.100.150  test_host        | --> SRV_G1
#
# tomcat-server-node2  192.168.100.152  grey deploy host | --> SRV_G2
#
# tomcat-server-node3  192.168.100.160  product host     |
#						         | --> SRV_G3
# tomcat-server-node4  192.168.100.162  product host     |

#### parameter spec ####
#
# METHOD:deploy|roll_back
#        deploy ----> deploy usual updated version of webapp.
# 	 roll_back -> roll back to last version of webapp.
# BRANCH:master|develop
#        master ----> deploy master branch of webapp code.
#        develop ---> deploy develop branch of webapp code to test server.
# SRV_GROUP:SRV_G1|SRV_G2|SRV_G3
# 	 SRV_G1 ----> servers of group1 for testing.
#        SRV_G2 ----> servers of group2 for gray deployment.
#        SRV_G3 ----> servers of group3 for product deployment.
# ROLL_BACK_NU:1-9
#	       1 ----> roll back to last version.
#	       2 ----> roll back to before last version.
#	       3 ----> roll back to before before last version.
#	       4 ----> roll back to ...

# Manually Run Example:
#./deploy-demo-new.sh deploy[|roll_back] master[|develop] SRV_G1[|SRV_G2|SRV_G3] 1[2|3|4|5|6|7|8|9]

declare -a GRAY_HOST
DATE=`date +%F_%H-%M-%S`

METHOD=$1
BRANCH=$2
SRV_GROUP=$3
ROLL_BACK_NU=$4

# modify project name here
PROJ="deploy-demo"

echo $METHOD
echo $BRANCH
echo $SRV_GROUP
echo "Project: deploy-demo"
echo

get_ip_list_and_remove_from_loadbalancer(){
    if [[ $SRV_GROUP = "SRV_G1" ]]; then 
        SRV_G1_IP="192.168.100.150"
        CURRENT_IP="192.168.100.150"
	echo "#### Removing host from loadbalancer... ####"
        for host in $SRV_G1_IP; do
            ssh root@192.168.100.154 "echo "disable server app/${host}" | socat stdio /run/haproxy/admin.sock"
            echo "Test server ${host} has removed from load balancer 192.168.100.154."
            ssh root@192.168.100.156 "echo "disable server app/${host}" | socat stdio /run/haproxy/admin.sock"
            echo "Test server ${host} has removed from load balancer 192.168.100.156."
        done
	echo
    elif [[ $SRV_GROUP = "SRV_G2" ]]; then
        SRV_G2_IP="192.168.100.152"
        CURRENT_IP="192.168.100.152"
	echo "#### Removing host from loadbalancer... ####"
        for host in $SRV_G2_IP; do
            ssh root@192.168.100.154 "echo "disable server app/${host}" | socat stdio /run/haproxy/admin.sock"
            echo "Gray deploy server ${host} has removed from load balancer 192.168.100.154."
            ssh root@192.168.100.156 "echo "disable server app/${host}" | socat stdio /run/haproxy/admin.sock"
            echo "Gray deploy server ${host} has removed from load balancer 192.168.100.156."
        done
	echo
    elif [[ $SRV_GROUP = "SRV_G3" ]]; then
        SRV_G3_IP="192.168.100.160 192.168.100.162"
        CURRENT_IP="192.168.100.160 192.168.100.162"
	echo "#### Removing host from loadbalancer... ####"
        for host in $SRV_G3_IP; do
            ssh root@192.168.100.154 "echo "disable server app/${host}" | socat stdio /run/haproxy/admin.sock ; echo "disable server app/${host}" | socat stdio /run/haproxy/admin.sock"
            echo "Product server ${SRV_G3_IP} has removed from load balancer 192.168.100.154."
            ssh root@192.168.100.156 "echo "disable server app/${host}" | socat stdio /run/haproxy/admin.sock ; echo "disable server app/${host}" | socat stdio /run/haproxy/admin.sock"
            echo "Product server ${SRV_G3_IP} has removed from load balancer 192.168.100.156."
        done
	echo
    fi
}

clone_code(){
    echo "#### Code cloning...####"
    cd /data/git/ && rm -rf ${PROJ}
    #git clone -b ${BRANCH} git@192.168.100.146:root/deploy-demo.git
    git clone -b ${BRANCH} git@192.168.100.146:root/${PROJ}.git
    chown jenkins.jenkins deploy-demo -R
    echo "Code cloned."
    echo
}

scan_code(){
    echo "#### Code scanning...####"
    cd /data/git/ && /usr/local/sonar-scanner/bin/sonar-scanner
    echo "Code scann finished."
    echo
}

# For java code
maven_compile_code(){
    echo "cd /data/git/java-proj && mvn clean package -Dmaven.test.skip=true"
    echo "Code compile finished."
    echo
}

archive_code(){
    echo "#### Code archiving...####"
    cd /data/git/${PROJ} && zip -r app.zip ./*
    echo "Code archived."
    echo
}

add_node(){
    ssh root@192.168.100.154 "echo "enable server app/$1" | socat stdio /run/haproxy/admin.sock"
    echo "Server $1 has added to load balancer 192.168.100.154."
    ssh root@192.168.100.156 "echo "enable server app/$1" | socat stdio /run/haproxy/admin.sock"
    echo "Server $1 has added to load balancer 192.168.100.156."
    echo
}

is_web_alive(){
    for host in ${CURRENT_IP}; do
        NUM=`curl -s -I -m 10 -o /dev/null -w %{http_code} http://${host}:8080/app/deploy-demo.html`
        if [[ ${NUM} -eq 200 ]];then
           echo "#### Test if the web is alive... ####"
           echo "The WEB of ${host} is alive, adding to loadbalancer..."
	   echo
           add_node ${host}
        else
           echo "The web of ${host} is not alive, please check manually, make sure tomcat is alive."
        fi
    done
}

downTom_scpArchive_upTom(){

    for host in ${CURRENT_IP}; do

        # stop tomcat
        echo "#### Stop tomcat... ####"
        ssh www@${host} "/etc/init.d/tomcat stop"
        echo "Tomcat on ${host} has stopped."
        echo

        # cp app-${DATE}.zip to servers
        echo "#### Deploy code to tomcat server... ####"
        scp -r /data/git/deploy-demo/app.zip www@${host}:/data/tomcat/appdir/app-${DATE}.zip
        ssh www@${host} "unzip /data/tomcat/appdir/app-${DATE}.zip -d /data/tomcat/webdir/app-${DATE} && rm -rf /data/tomcat/webapps/app && ln -sv /data/tomcat/webdir/app-${DATE} /data/tomcat/webapps/app"
	ssh www@${host} "/bin/rm -rf /data/tomcat/appdir/*"
        echo "zipped code transfered."
        echo
	
        # start tomcat
        echo "#### Start tomcat... ####"
        ssh www@${host} "/etc/init.d/tomcat start"
        echo "Tomcat on ${host} has started."
        echo

    done
   
}

roll_back(){

    if [[ $SRV_GROUP = "SRV_G3" ]]; then 
        echo "#### Roll back to last version... ####"
	ROLL_BACK_TO=$(($1 + 1))
	echo $1
	echo $ROLL_BACK_TO
	for host in ${CURRENT_IP}; do
	    INFO=`ssh www@${host} "ls -l /data/tomcat/webdir/* -dt | head -n ${ROLL_BACK_TO} | tail -n1 | awk '{print $NF}'"`
	    LAST_VER=$(basename `echo $INFO | awk '{print $NF}'`)
	    ssh www@${host} "rm -rf /data/tomcat/webapps/app && ln -sv /data/tomcat/webdir/${LAST_VER} /data/tomcat/webapps/app"
        echo "#### Roll back finished. ####"
	done
    fi

}

del_old_ver(){
    for host in ${CURRENT_IP}; do
	echo "Delete the old version of ${host}."
        VER_NU=`ssh www@${host} "/bin/ls /data/tomcat/webdir/app-* -dlt | wc -l"`
	echo "You got $VER_NU versions"
	if [[ ${VER_NU} -gt 5 ]]; then
            for OLD_VER in `ssh www@${host} ""ls /data/tomcat/webdir/app-* -dlt | tail -n $((${VER_NU}-5)) | awk '{print $NF}'""`; do 
		echo "OLD_VER is ${OLD_VER}"
	        ssh www@${host} "/bin/rm -rf ${OLD_VER}"
		echo "OLD_VER is deleted."
	    done
	fi
    done
}

main(){

case $1 in
    deploy)
        get_ip_list_and_remove_from_loadbalancer;
	clone_code;
	scan_code;
	archive_code;
        downTom_scpArchive_upTom
        is_web_alive;
	del_old_ver;
	;;
    roll_back)
        get_ip_list_and_remove_from_loadbalancer;
        roll_back ${ROLL_BACK_NU};
        is_web_alive;
	;;
esac
}

main $1 $2 $3 $4
