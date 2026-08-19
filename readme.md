> 以下为转发博客原文，不定时更新，最新进度访问博客：https://bigpig.ongridea.com/rjnld4
>
> 原文标题：【技术 FPGA-6】猪蹄UDP开源接口 · 大猪蹄子的个人博客

---

## **简介**

* Github链接：[GitHub - BigPig-Bro/UDP](https://github.com/BigPig-Bro/udp)

* 这是一个UDP（带ARP\ICMP（ping)）的通用接口工程汇总，目前提供了各种平台上的RGMII、GMII接口10/100/1000M范例，调试答疑见[【技术 FPGA-5】调试FPGA网口（UDP）常见问题](https://bigpig.ongridea.com/vo8hfn)

* UDP已单独整理封装接口，范例提供回环和主动发送两个外围测试

* 目前该UDP接口参数如下：

     1. 支持被动ARP（PC可以ARP访问到FPGA支持被动ICMP部分（PC可以ping到FPGA，该功能固定Windows默认32字节，linux测试请注意）

     2. 支持自动计算FCS（你只管喂中间的数据就行

     3. 支持自动增加SFD（你只管喂中间的数据就行

     4. 支持自动补0（数据段低于18个字符的自动补零，避免触发以太网帧最小60字符限制

## **UDP核文件结构**

**（以下以Xilinx版本为例，其他厂家的不再重复说明）**

### **1-rgmii_1g_8b**（gmii和10/100M版本几乎一样，不再单独说明）

**udp_top**：接口的顶层文件，负责模块连接

* **gmii_top**：对外的顶层文件，负责输入输出gmii格式的数据

     * **gmii_tx**：负责将数据添加SFD头、补0以及FCS尾

     * **gmii_rx**：负责检测数据并去掉SFD头

     * **gmii2rgmii**：负责gmii和rgmii接口互转

       * **rx_dly_pll**：idelay需要的200M时钟

       * **IDDR**：rgmii需要的串并转换

       * **ODDR**：rgmii需要的串并转换

* **rx_mux**：负责识别icmp和arp单独发出去，其余发给user

* **icmp**：负责识别是不是当前FPGA的ping报文，并响应回复

* **arp**：负责识别是不是当前FPGA的arp报文，并响应回复

* **tx_mux**：负责轮询icmp\arp\user数据需求

![](https://static.gridea.dev/7da010b3-a38e-41cc-bb67-30a423b67928/bxBi9ury1.png)

## **接口时序**

目前所有例程的UDP对User接口相同

* **i_rst_n**：低电平复位

* **输出接口**

     * **o_usr_rx_data**：输出的用户数据，从MAC开始，无SFD，有补0和FCS

     * **o_usr_rx_valid**：输出的用户数据 valid，高电平有效

     * **o_usr_rx_last** ：输出的用户数据 valid last，高电平有效

* **输入接口**

     * **i_usr_tx_data**：输入的用户数据，从MAC开始，无SFD、补0和FCS

     * **i_usr_tx_wr**：输入的用户数据 valid，高电平有效

     * **i_usr_tx_last**：输入的用户数据 valid last，高电平有效

* **o_tx_busy**：发送接口忙，高电平有效

## **范例介绍**

* **仓库范例工程说明**

     * 厂家二位编码+芯片系列编码+工程接口

     * **厂商编码**：XI（Xilinx)、AL（Altera）、GW（Gowin）

     * **芯片系列**：C4（Cyclone IV）、C5（Cyclone V）、C10（Cyclone 10）、5A（GW5A）、2A（GW2A）、A7（Artix-7)、K7（Kintex-7)（力竭了

     * **工程接口：**

       * rgmii_10_100M_1G_8b：基于RGMII、10/100M/1G速度、用户接口8位的测试例程

       * gmii_1b_8b：基于GMII、其余参数同上

* **测试工程环境**：（如果你想1:1复刻的话）

     * **GW_2A_gmii_10_100M_1G_8b**：

       * Gowin GW2A，猪蹄板GW020AB+猪蹄gmii
     * **GW_5A_gmii_10_100M_1G_8b_138**：

       * Gowin GW5A，猪蹄板GW138/060AB（138K）+猪蹄gmii
     * **AL_C5_gmii_10_100M_1G_8b**：

       * Altera Cyclone V，猪蹄板XI077AB+猪蹄gmii
     * **AL_C5_rgmii_10_100M_1G_8b**：

       * Altera Cyclone V，猪蹄板XI077AB板载网口
     * **XI_A7_rgmii_10_100M_1G_8b**：

       * Xilinx Artix-7，猪蹄板XI050CD/AB板载网口
     * **XI_A7_gmii_10_100M_1G_8b**：

       * Xilinx Artix-7，猪蹄板XI050CD+猪蹄gmii
     * **XI_K7_rgmii_10_100M_1G_8b**：

       * Xilinx Kintex-7，学校某退役7K325T板载网口
* **范例其他工程文件**：

     * **loop_top**：将用户数据原文返回

     * **test_top**：根据串口字符0 1 2执行不同测试数据，优先级高于loop_top

       * 0-什么也不干（上电默认）

       * 1-每秒发送一个Payload包（默认1024字节，Parameter可配）

       * 2-以最小帧间隔发送Payload包（测试最大带宽，rgmii/gmii一般在970Mbps

![](https://static.gridea.dev/7da010b3-a38e-41cc-bb67-30a423b67928/r99M6zQfM.png)

## **测试流程**

1. 所有例程接口一致，因此以下测试流程也一致（不同速度，实际带宽不一样）

2. PC网口配置IP为192.168.1.100，子网掩码255.255.255.0，网关（不需要）192.168.1.1，DNS（不需要）4.4.4.4

3. 如果只尝试ARP和PING，直接给对应开发板烧录工程自带的bit；如果想要测试串口指令，需要自行修改为自己电脑的MAC

4. 连接PC网口与工程对应约束的网口（别插错了

5. 打开CMD，尝试ping 192.168.1.210，能通

6. 打开任务管理器，打开串口助手对应FPGA的端口，波特率9600，发送字符1，回复>1，此时能看到网口带宽8Kbps（设定的每个包1024字节，每秒发一次）。当然你愿意开网络调试助手，也看得到，就是字符有点多

7. 发送字符2，回复>2，此时能看到网口带宽970Mbps（如果你开了Wireshark或者网络调试助手会更低一点，因为显示不出来卡死了

8. 发送字符0，回复>0，一切归于平静

9. 打开网络调试助手，在UDP模式，目的IP192.168.1.210：8000，随便发点12345，FPGA回复原文

10. 测试全部完成

## **可能的问题**

1. IDELAY及相关时序参数是在我手上板子调的，你手上那个需要自己调

2. o_tx_busy会有一定延迟，万一你发出去的数据刚好和icmp\arp撞了呢？（虽然概率极小，因为arp一般只会执行一次，icmp的ping也需要人为执行

3. 没有处理rx_err和tx_err。真有人在乎这个？

4. UDP报文的ID号固定，Windows通信不查这个。真有人在乎这个？

5. UDP报文的check sum固定0，Windows通信不查这个。真有人在乎这个？

6. ARP的目的IP MAC 端口应该引出来，谁来arp，FPGA就跟谁通信，而不是现在这样写死，然后重编译

7. 例程简化了loop_top和test_top对同一用户端口仲裁，可能冲突，你别两个一起测就行

8. 默认MTU 1500，支持巨型帧（没测试，反正接口没限制）

9. 不支持握手速度10/100/1000等自动切换，理论上可以读MDIO，但是感觉一般都是写死用的；但是FPGA写死不会影响到PHY和电脑握手，如果你要测试RGMII接口连到10/100M，要么真的找个10M或者100M的网口，要么去设备管理器->对应网卡->属性->高级->连接速度，手动改成10M或100M 全双工即可

10. 不支持10/100M Half/Full识别和处理，老古董留下来的石山，2026年应该找不到纯Half的设备

## **版本更新**

260812：初始版本
260814：更新GMII版本
260815：更新版本接口描述
260816：更新Altera Cyclone V版本、Gowin GW2A版本
260817：更新Gowin GW5A版本
260818：更新Xilinx Kintex-7版本
260819：更新10/100/1000三速版本，更新对应描述
