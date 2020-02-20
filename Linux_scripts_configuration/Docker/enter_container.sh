#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Usage: `basename $0` CONTAINER_NAME"
    exit 80;
fi

enter(){
    local C_NAME=$1
    PID=`docker inspect -f "{{.State.Pid}}" ${C_NAME}`
    nsenter -t ${PID} -m -u -n -i -p
}

enter $1
