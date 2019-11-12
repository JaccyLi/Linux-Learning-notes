# :arrow_forward:实验：删除centos6.1下的/boot/下的所有文件和/etc/fstab，恢复之

## :black_medium_square:开机现象

> 我跳，忘记截屏了:weary::weary::weary::weary::weary::weary::weary::weary::weary::weary::weary::weary::weary::weary::weary::weary::weary::weary:

## :one:删除之

`rm -rf /boot/* /etc/fstab`

## :two:救援模式

## :three:fdisk -l查看一下分区情况，猜猜哪个是哪个

## :four:建个临时文件夹/mnt/tmp，分别把每个分区挂载进来看看

`mkdir /mnt/tmp`
`mount /dev/sd[1-5] /mnt/tmp`

## :five:发现/dev/sda2是老子的根

`mount /dev/sd2 /mnt/tmp`

## :six:新增文件/etc/fstab,编辑之

`vim /etc/fstab`

```
/dev/sda1    /boot   ext4   defaults 0 0
/dev/sda2    /       ext4   defaults 0 0
/dev/sda3    /data   ext3   defaults 0 0
/dev/sda5    swap    swap   defaults 0 0
```

## :seven:保存退出，再次进救援模式

## :eight:切根，进入/boot目录，从光盘拷贝内核文件

`chroot /mnt/sysimage`
`cd /boot`
`mount /dev/sr0 /mnt`
`cp /mnt/isolinux/vmlinuz .`

## :nine:安装grub，生成initramfs.img

`grub-install /dev/sda`
`mkinitrd initramfs-$(uname -r).img $(uname -r)`
`mv initramfs....img initramfs.img`

## :keycap_ten:新增并编辑/grub/grub.conf

`vim /grub/grub.conf`

```
default=0
timeout=5
hiddenmenu
title welcome to stevenux
root (hd0,0)
kernel /vmlinuz root=/dev/sda
initrd /initramfs.img
```

## :one::one:sync几下

## :arrow_left:exit

## :repeat:reboot

