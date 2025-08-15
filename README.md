```
#
# Copyright (C) 2025 The TWRP Project
#
# SPDX-License-Identifier: Apache-2.0
#
```
## How to compile
1.sync twrp-12.1 source code

2.git clone this repo to '/device/huawei/enjoy10e'

<pre>
make recoveryimage
</pre>
## How to flash
1.unlock bootloader

<pre>
fastboot flash recovery_ramdisk recovery.img
fastboot flash recovery_vendor recovery_vendor.img
</pre>
## Bug
1.touch screen

添加下维修思路传感器hal补齐

2.FBE2.0（Not work fully）
## Tips
没错，这个就是圾皇畅享10e的twrp，还在修复中，尚未完善，欢迎pr，有什么问题可以发我

邮件 wangguanzhiabcd@126.com

或者直接在酷安联系我，搜索SKDushow

The Huawei enjoy 10E (codenamed "enjoy10e") is an entry-level budget tablet from Huawei.

It was released in May 2020.

## Device specifications

Basic   | Spec Sheet
-------:|:-------------------------
Platform | MediaTek MT6765 (Octa-core Cortex-A53)
RAM & Storage | 4GB/64GB, 4GB/128 (LPDDR3 RAM, eMMC 5.1 storage)
Shipped Android Version | EMUI 10.0 (based on Android 10, no Google Play Services)
Battery | Non-removable, 5000 mAh
Display | 6.3″ LCD, 60Hz, 720x1600 (189 ppi)
Rear camera | Dual 13 MP, f/1.8, 27mm (wide), PDAF 2 MP, f/2.4, (depth)
Front camera | 8 MP, f/2.0
Connectivity | Wi-Fi / LTE

## Device picture

![Huawei MatePad T8](https://fdn2.gsmarena.com/vv/bigpic/huawei-enjoy-10-e.jpg "Huawei Enjoy10E")
