#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-11-02
#FileName:		    matrix_transpose.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		matrix_transpose.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

read -p "Please input the order of the matrix: " ORDER
echo  -e "Generated matrix as follows: \v" 
TOTAL_NUM=$[ORDER**2]
declare -i X=1
declare -i Y=1
declare -i M=1
declare -i N=1
declare -a NUMS
declare -a TRANS_NUMS

#echo $TOTAL_NUM

#generate_matrix()
#{
#for (( i=1 ; i <= TOTAL_NUM ; i++ )); do
#    echo -ne "$i\t"
#    NUMS[$X$i]=$i
#    if [[ $(($i%$ORDER)) -eq 0 ]]; then
#        echo -e "\v"
#        NUMS[$X$i]=$i
#        let X++
#    fi
#done
#let X=1
#echo -e "\n\n"
#}

generate_matrix()
{
for (( i=1 ; i <= TOTAL_NUM ; i++ )); do
    echo -ne "$i\t"
    NUMS[$X$Y]=$i
   # echo -ne "${NUMS[$X$Y]}\t"
   # TRANS_NUMS[$M$N]=${NUMS[$Y$X]}
    let Y++
    if [[ $(($i%$ORDER)) -eq 0 ]]; then
        echo -e "\v"
        NUMS[$X$Y]=$i
   #     echo -ne "${NUMS[$X$Y]}\t"
   #     TRANS_NUMS[$M$N]=${NUMS[$Y$X]}
        let X++
    fi
done
echo -e "\n\n"
}

transpose_matrix()
{

for (( i=1 ; i <= TOTAL_NUM ; i++ )); do
    #echo -ne "$i\t"
    TRANS_NUMS[$M$N]=${NUMS[$Y$X]}
    echo -ne "${TRANS_NUMS[$M$N]}\t"
    let N++
    if [[ $(($i%$ORDER)) -eq 0 ]]; then
        #echo -e "\v"
        echo -e "${TRANS_NUMS[$M$N]}\v"
        TRANS_NUMS[$M$N]=${NUMS[$Y$X]}
        let M++
    fi
done

#echo "Generated matrix with no format:"
#echo ${NUMS[*]}
#
#for (( i=1 ; i <= TOTAL_NUM ; i++ )); do
#    if [[ $X != $i ]]; then 
#        TRANS_NUMS=NUMS[$i$X]
#
#    fi
#done
#
echo "Transposed matrix with no format:"
echo ${TRANS_NUMS[*]}


}


main()
{

generate_matrix

transpose_matrix


}

main
