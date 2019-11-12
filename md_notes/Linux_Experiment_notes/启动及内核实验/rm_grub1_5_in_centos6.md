# :arrow_forward:实验：删除grub1_5阶段，恢复之

## :black_medium_square:开机现象

> 

## :one:备份一下MBR(前446字节)和分区信息(446字节后的64字节)及前面510字节后的两字节标记位(55 AA)

`dd if=/dev/sda of=/data/mbr_partition.bak bs=1 count=512`

## :two:grub第1.5阶段存储在512字节后面27个扇区，删除之

`dd if=/dev/zero of=/dev/sda bs=1 count=10240 seek=512`

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

