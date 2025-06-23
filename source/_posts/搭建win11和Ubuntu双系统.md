---

title: 搭建win11和Ubuntu双系统保姆级教程
---

# 前言

&emsp;&emsp;使用windows开发的小伙伴来说，开发的便捷性远不如MacOs和Linux系统操作方便，前者由于是苹果电脑转配（黑苹果容易导致被官方查封），且苹果电脑售卖价格较高，所以Linux操作系统是开发者的不二之选。

&emsp;&emsp;但Linux操作系统的缺点是除了开发，其余的办公需求连windows的毛都赶不上，且windows还可以玩游戏，所以windows+Linux的双系统组合是十分完美的。

&emsp;&emsp;完成双系统的搭建一般来说有两种方法，一种是使用虚拟机（VM）来完成， 但这样体验到的Linux操作系统是丐版的，只能作为学习阶段来使用，作为开发的主力系统还不够。第二种就是本文讲述的办法，直接搭建双系统。

# 工具准备

## Linux镜像

&emsp;&emsp;Linux市面上存在很多的发行版，Centos和Ubuntu都可以，是比较常见的两种，但由于Centos已经停止维护了，所以本文选择Ubuntu。

优先下载长期维护版本LTS [下载链接](https://cn.ubuntu.com/download/desktop)

![](/img/Ubuntu_LST.png)

## U盘（不是必选）

&emsp;&emsp;有过重装windows系统经验的小伙伴应该知道，需要现将系统的镜像文件烧录到一个U盘当中，搭建双系统是同样的道理，但由于镜像文件的大小一般都是5-6GB，所以准备的U盘至少需要8GB左右，且这个U盘是空的（装系统也会格式化U盘）。

&emsp;&emsp;其实使用U盘来装系统不是唯一的方法，且这样对于U盘的损耗很大，作者就因此坏了一块U盘。

&emsp;&emsp;下面本文会讲述使用两种方式来搭建双系统。

## 烧录工具（如果使用U盘装机需要）

&emsp;&emsp;U盘的烧录工具有很多，这里推荐使用U盘烧录工具 [EaseUS](https://www.easeus.com/cn/disk-to-go/download.html)

## 其余工具（不使用U盘装机）

&emsp;&emsp;如果不使用U盘装机，则需要下载一个App-**EasyUEFI**,用于添加启动项，软件在这里不详细介绍(软件需要收费，如果有版权意识的小伙伴就采用U盘装机)

&emsp;&emsp;破解版地址提供如下：[百度网盘](https://www.easyuefi.com/index-cn.html)

---
# 硬盘空间准备
&emsp;&emsp;在开始搭建双系统之前，需要先对硬盘空间进行规划，这里需要准备两个分区，一个用于Windows系统，一个用于Linux系统。

&emsp;&emsp;有条件的同学最好直接使用两块硬盘（不是C盘和D盘这样的两块，因为C盘和D盘很可能是一块SSD分的，是两块SSD），这样Windows和Linux系统之间就无文件共享问题，搭建双系统的过程会更简单，且Linux系统如果出问题了（出问题的概率不小。。。）也不会影响到Windows系统。

&emsp;&emsp;如果没有两块SSD，就需要手动进行分区，教程如下：
