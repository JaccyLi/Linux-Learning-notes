# :arrow_forward:实验：破坏centos6.1的/boot/initramfs.img文件，修复之

## :black_medium_square:开机现象

> 开机引导系统后可以识别内核所在的boot分区，可以选择内核启动，选择内核后光标卡在屏幕左上角，无法启动系统

## :one:第一步：备份initramfs-2.6.32-754.e16.x86_64.img(防止实验失败，打脸:new_moon_with_face:)

`cp -a /boot/initramfs-2.6.32-754.e16.x86_64.img /data/initramfs-2.6.32-754.e16.x86_64.img.bak`

## :two:第二步：挂载centos6.1光盘:dvd:，进入救援模式

## :three:第三步：切根:hocho::grinning:

`chroot /mnt/sysimage`

## :four:第四步：使用mkinitrd命令生成initramfs.img文件，借助其提供的文件系统驱动辅助vmlinuz内核挂载根分区

`mkinitrd initramfs-$(uname -r).img $(uname -r)` 注意：该命令需要使用内核版本作为参数

## :arrow_left:exit

## :repeat:reboot