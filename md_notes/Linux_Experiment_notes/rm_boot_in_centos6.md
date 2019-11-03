# :arrow_forward:实验：删除centos6.1系统的/boot文件夹，恢复之

## :black_medium_square:开机现象

>![](png/2019-11-03-15-07-34.png) 

## :one:删除/boot

`rm -rf /boot`

## :two:连接光盘，进入救援模式

## :three:切根

`chroot /mnt/sysimage`

## :four:挂载光盘

`mount /dev/sr0 /mnt`

## :five:拷贝linux内核文件到/boot

`cp /mnt/isolinux/vmliuz /boot`

## :six:安装grub

`grub-install /dev/sda2`

## :seven:生成initramfs.img文件

`initrd /boot/initramfs-$(uname -r).img $(uname -r)`

## :eight:创建并编辑/boot/grub/grub.conf

`vim /boot/grub/grub.conf`
```
default=0
timeout=5
hiddenmenu
title welcome to centos
root (hd0,0)
kernel /vmlinuz root=/dev/sda
initrd /initramfs-2.6.32-754.e16.x86_64.img
```

## :nine:sync几下

## :arrow_left:exit

## :repeat:reboot

