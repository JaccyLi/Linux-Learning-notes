@[TOC](shell脚本for循环语句)
###### 循环：
==进入条件==  ==退出条件==
*for 变量 in 列表：do
	循环体
	done*
==或者==
*for 变量 in 列表
do
	循环体
done*

eg：
for i in 1,2,3,4,5,6,7,8,9,10;do
加法运算
done

###### 如何生成列表？
{1..100} #整数列表展开
seq [起始数 [步进数]] 结束数  #[起始数 [步进数]]可以省略  
\`ls /etc` 也可以生成序列

###### 练习：
计算1-100的整数和？
```shell
#!/bin/bash
declare -I SUM=0  #-i integer 将SUM声明为整数
for i in {1..100};do
let SUM=$[ $SUM + $I ]
done
echo "the sum is $SUM."
```

