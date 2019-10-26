<center> <font face="黑体" size=6 color=grey>Linux系统性能监控和管理</font></center>

# 

## 1.top监控系统进程

## 2.free命令查看内存空间使用情况

## 3.vmstat命令查看虚拟内存信息

```bash
[root@centos8 ~]#vmstat
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 1  0 351744 221400     48 310228    0    3    12    10   96  123  0  1 99  0  0
```

```bash
[root@centos8 ~]#vmstat -s
      1601624 K total memory
      1070076 K used memory
       304720 K active memory
       355440 K inactive memory
       220684 K free memory
           48 K buffer memory
       310816 K swap cache
      3145724 K total swap
       351488 K used swap
      2794236 K free swap
        23953 non-nice user cpu ticks
          283 nice user cpu ticks
        51189 system cpu ticks
     15032629 idle cpu ticks
          450 IO-wait cpu ticks
        22150 IRQ cpu ticks
         9239 softirq cpu ticks
            0 stolen cpu ticks
      1831057 pages paged in
      1529731 pages paged out
        15528 pages swapped in
       103783 pages swapped out
     14519323 interrupts
     18668588 CPU context switches
   1572022693 boot time
       175270 forks
```

## 4.使用iostat统计CPU和设备IO信息

```bash
[root@centos8 ~]#iostat
Linux 4.18.0-80.el8.x86_64 (centos8.suosuoli)   10/26/19        _x86_64_        (4 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.16    0.00    0.55    0.00    0.00   99.29

Device             tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
nvme0n1           1.64        48.17        40.38    1830027    1534327
scd0              0.00         0.03         0.00       1106          0
```

## 5.iftop显示带宽使用情况

```bash
                  12.5Kb            25.0Kb             37.5Kb            50.0Kb       62.5Kb
└─────────────────┴─────────────────┴──────────────────┴─────────────────┴──────────────────centos8.suosuoli                 => 172.20.1.1                       1.70Kb  1.77Kb  1.97Kb
                                 <=                                   184b    258b    299b
centos8.suosuoli                 => public1.alidns.com                284b    343b    318b
                                 <=                                   592b    690b    628b
224.0.0.251                      => 172.20.1.156                        0b      0b      0b
                                 <=                                     0b    275b    172b
172.20.255.255                   => 172.20.2.20                         0b      0b      0b
                                 <=                                     0b    187b    117b
172.20.255.255                   => 172.20.30.30                        0b      0b      0b
                                 <=                                     0b     58b     36b
255.255.255.255                  => 172.20.2.20                         0b      0b      0b


────────────────────────────────────────────────────────────────────────────────────────────TX:             cum:   4.57KB   peak:   2.81Kb              rates:   1.98Kb  2.10Kb  2.28Kb
RX:                    2.49KB           4.09Kb                        776b   1.47Kb  1.24Kb
TOTAL:                 7.06KB           6.90Kb                       2.74Kb  3.57Kb  3.53Kb
```

## 6.pmap显示某进程对应的内存映射

```bash
[root@centos8 ~]#pmap 2762   # gvfsd进程的进程号为2762
2762:   /usr/libexec/gvfsd
0000562abe7ef000     32K r-x-- gvfsd
0000562abe9f6000      4K r---- gvfsd
0000562abe9f7000      4K rw--- gvfsd
0000562abfa5b000    532K rw---   [ anon ]
00007f4cc4000000    132K rw---   [ anon ]
00007f4cc4021000  65404K -----   [ anon ]
00007f4cc8000000    132K rw---   [ anon ]
00007f4cc8021000  65404K -----   [ anon ]
00007f4ccc000000    132K rw---   [ anon ]
00007f4ccc021000  65404K -----   [ anon ]
00007f4cd0000000    132K rw---   [ anon ]
00007f4cd0021000  65404K -----   [ anon ]
00007f4cd4000000    132K rw---   [ anon ]
00007f4cd4021000  65404K -----   [ anon ]
00007f4cdb7ff000      4K -----   [ anon ]
00007f4cdb800000   8192K rw---   [ anon ]
00007f4cdc000000    132K rw---   [ anon ]
00007f4cdc021000  65404K -----   [ anon ]
00007f4ce0000000    132K rw---   [ anon ]
00007f4ce0021000  65404K -----   [ anon ]
00007f4ce4000000    132K rw---   [ anon ]
00007f4ce4021000  65404K -----   [ anon ]
00007f4ce8a84000      4K -----   [ anon ]
00007f4ce8a85000   8192K rw---   [ anon ]
00007f4ce9285000      4K -----   [ anon ]
00007f4ce9286000   8192K rw---   [ anon ]
00007f4ce9a86000      4K -----   [ anon ]
00007f4ce9a87000   8192K rw---   [ anon ]
00007f4cea287000      4K -----   [ anon ]
00007f4cea288000   8192K rw---   [ anon ]
00007f4ceaa88000      4K -----   [ anon ]
00007f4ceaa89000   8192K rw---   [ anon ]
00007f4ceb289000 212648K r---- locale-archive
00007f4cf8233000     28K r-x-- librt-2.28.so
00007f4cf823a000   2048K ----- librt-2.28.so
00007f4cf843a000      4K r---- librt-2.28.so
00007f4cf843b000      4K rw--- librt-2.28.so
00007f4cf843c000     24K r-x-- libuuid.so.1.3.0
00007f4cf8442000   2048K ----- libuuid.so.1.3.0
00007f4cf8642000      4K r---- libuuid.so.1.3.0
00007f4cf8643000      4K rw---   [ anon ]
00007f4cf8644000    304K r-x-- libblkid.so.1.1.0
00007f4cf8690000   2044K ----- libblkid.so.1.1.0
00007f4cf888f000     20K r---- libblkid.so.1.1.0
00007f4cf8894000      4K rw--- libblkid.so.1.1.0
00007f4cf8895000      4K rw---   [ anon ]
00007f4cf8896000    524K r-x-- libpcre2-8.so.0.7.1
00007f4cf8919000   2044K ----- libpcre2-8.so.0.7.1
00007f4cf8b18000      4K r---- libpcre2-8.so.0.7.1
00007f4cf8b19000      4K rw--- libpcre2-8.so.0.7.1
00007f4cf8b1a000     92K r-x-- libgcc_s-8-20180905.so.1
00007f4cf8b31000   2044K ----- libgcc_s-8-20180905.so.1
00007f4cf8d30000      4K r---- libgcc_s-8-20180905.so.1
00007f4cf8d31000      4K rw--- libgcc_s-8-20180905.so.1
00007f4cf8d32000    340K r-x-- libmount.so.1.1.0
00007f4cf8d87000   2044K ----- libmount.so.1.1.0
00007f4cf8f86000     12K r---- libmount.so.1.1.0
00007f4cf8f89000      4K rw--- libmount.so.1.1.0
00007f4cf8f8a000      4K rw---   [ anon ]
00007f4cf8f8b000     80K r-x-- libresolv-2.28.so
00007f4cf8f9f000   2044K ----- libresolv-2.28.so
00007f4cf919e000      4K r---- libresolv-2.28.so
00007f4cf919f000      4K rw--- libresolv-2.28.so
00007f4cf91a0000      8K rw---   [ anon ]
00007f4cf91a2000    156K r-x-- libselinux.so.1
00007f4cf91c9000   2044K ----- libselinux.so.1
00007f4cf93c8000      4K r---- libselinux.so.1
00007f4cf93c9000      4K rw--- libselinux.so.1
00007f4cf93ca000      8K rw---   [ anon ]
00007f4cf93cc000     88K r-x-- libz.so.1.2.11
00007f4cf93e2000   2044K ----- libz.so.1.2.11
00007f4cf95e1000      4K r---- libz.so.1.2.11
00007f4cf95e2000      4K rw---   [ anon ]
00007f4cf95e3000    448K r-x-- libpcre.so.1.2.10
00007f4cf9653000   2044K ----- libpcre.so.1.2.10
00007f4cf9852000      4K r---- libpcre.so.1.2.10
00007f4cf9853000      4K rw--- libpcre.so.1.2.10
00007f4cf9854000     28K r-x-- libffi.so.6.0.2
00007f4cf985b000   2048K ----- libffi.so.6.0.2
00007f4cf9a5b000      4K r---- libffi.so.6.0.2
00007f4cf9a5c000      4K rw--- libffi.so.6.0.2
00007f4cf9a5d000    124K r-x-- libgpg-error.so.0.24.2
00007f4cf9a7c000   2048K ----- libgpg-error.so.0.24.2
00007f4cf9c7c000      4K r---- libgpg-error.so.0.24.2
00007f4cf9c7d000      4K rw--- libgpg-error.so.0.24.2
00007f4cf9c7e000     12K r-x-- libdl-2.28.so
00007f4cf9c81000   2044K ----- libdl-2.28.so
00007f4cf9e80000      4K r---- libdl-2.28.so
00007f4cf9e81000      4K rw--- libdl-2.28.so
00007f4cf9e82000   1108K r-x-- libgcrypt.so.20.2.3
00007f4cf9f97000   2044K ----- libgcrypt.so.20.2.3
00007f4cfa196000      8K r---- libgcrypt.so.20.2.3
00007f4cfa198000     20K rw--- libgcrypt.so.20.2.3
00007f4cfa19d000      4K r-x-- libgthread-2.0.so.0.5600.4
00007f4cfa19e000   2044K ----- libgthread-2.0.so.0.5600.4
00007f4cfa39d000      4K r---- libgthread-2.0.so.0.5600.4
00007f4cfa39e000      4K rw---   [ anon ]
00007f4cfa39f000   1768K r-x-- libc-2.28.so
00007f4cfa559000   2048K ----- libc-2.28.so
00007f4cfa759000     16K r---- libc-2.28.so
00007f4cfa75d000      8K rw--- libc-2.28.so
00007f4cfa97e000      4K rw--- libpthread-2.28.so
00007f4cfa97f000     16K rw---   [ anon ]
00007f4cfa983000      8K r-x-- libutil-2.28.so
00007f4cfa985000   2048K ----- libutil-2.28.so
00007f4cfab85000      4K r---- libutil-2.28.so
00007f4cfab86000      4K rw--- libutil-2.28.so
00007f4cfab87000   1108K r-x-- libglib-2.0.so.0.5600.4
00007f4cfac9c000   2048K ----- libglib-2.0.so.0.5600.4
00007f4cfae9c000      4K r---- libglib-2.0.so.0.5600.4
00007f4cfae9d000      4K rw--- libglib-2.0.so.0.5600.4
00007f4cfae9e000      4K rw---   [ anon ]
00007f4cfae9f000    320K r-x-- libgobject-2.0.so.0.5600.4
00007f4cfaeef000   2048K ----- libgobject-2.0.so.0.5600.4
00007f4cfb0ef000      4K r---- libgobject-2.0.so.0.5600.4
00007f4cfb0f0000      4K rw--- libgobject-2.0.so.0.5600.4
00007f4cfb0f1000   1644K r-x-- libgio-2.0.so.0.5600.4
00007f4cfb28c000   2048K ----- libgio-2.0.so.0.5600.4
00007f4cfb48c000     28K r---- libgio-2.0.so.0.5600.4
00007f4cfb493000      4K rw--- libgio-2.0.so.0.5600.4
00007f4cfb494000      8K rw---   [ anon ]
00007f4cfb496000    320K r-x-- libsecret-1.so.0.0.0
00007f4cfb4e6000   2048K ----- libsecret-1.so.0.0.0
00007f4cfb6e6000     16K r---- libsecret-1.so.0.0.0
00007f4cfb6ea000      4K rw--- libsecret-1.so.0.0.0
00007f4cfb6eb000     12K r-x-- libgmodule-2.0.so.0.5600.4
00007f4cfb6ee000   2044K ----- libgmodule-2.0.so.0.5600.4
00007f4cfb8ed000      4K r---- libgmodule-2.0.so.0.5600.4
00007f4cfb8ee000      4K rw--- libgmodule-2.0.so.0.5600.4
00007f4cfb8ef000   1148K r-x-- libp11-kit.so.0.3.0
00007f4cfba0e000   2044K ----- libp11-kit.so.0.3.0
00007f4cfbc0d000     44K r---- libp11-kit.so.0.3.0
00007f4cfbc18000     40K rw--- libp11-kit.so.0.3.0
00007f4cfbc22000    224K r-x-- libgck-1.so.0.0.0
00007f4cfbc5a000   2044K ----- libgck-1.so.0.0.0
00007f4cfbe59000      8K r---- libgck-1.so.0.0.0
00007f4cfbe5b000      4K rw--- libgck-1.so.0.0.0
00007f4cfbe5c000    592K r-x-- libgcr-base-3.so.1.0.0
00007f4cfbef0000   2044K ----- libgcr-base-3.so.1.0.0
00007f4cfc0ef000     48K r---- libgcr-base-3.so.1.0.0
00007f4cfc0fb000      4K rw--- libgcr-base-3.so.1.0.0
00007f4cfc0fc000      4K rw---   [ anon ]
00007f4cfc0fd000    228K r-x-- libgvfscommon.so
00007f4cfc136000   2048K ----- libgvfscommon.so
00007f4cfc336000     24K r---- libgvfscommon.so
00007f4cfc33c000      4K rw---   [ anon ]
00007f4cfc33d000    160K r-x-- libgvfsdaemon.so
00007f4cfc365000   2044K ----- libgvfsdaemon.so
00007f4cfc564000      8K r---- libgvfsdaemon.so
00007f4cfc566000      4K rw--- libgvfsdaemon.so
00007f4cfc567000    160K r-x-- ld-2.28.so
00007f4cfc769000     48K rw---   [ anon ]
00007f4cfc78d000      8K rw---   [ anon ]
00007f4cfc78f000      4K r---- ld-2.28.so
00007f4cfc790000      4K rw--- ld-2.28.so
00007f4cfc791000      4K rw---   [ anon ]
00007ffd2793d000    132K rw---   [ stack ]
00007ffd279db000     12K r----   [ anon ]
00007ffd279de000      8K r-x--   [ anon ]
ffffffffff600000      4K r-x--   [ anon ]
 total           855884K
```

## 7.dstat命令用来统计系统资源(代替vmstat和iostat)

## 8.iotop命令用来监视磁盘I/O使用状况

- iotop命令是一个用来监视磁盘I/O使用状况的top类工具iotop具有与top相似的UI，其中包括
PID、用户、I/O、进程等相关信息，可查看每个进程是如何使用IO 

## 9.nload命令查看网络实时吞吐量 

## 10.lsof命令用来查看当前系统文件

