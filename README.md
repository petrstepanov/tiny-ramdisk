Tiny Ramdisk
------------

Trivial persistent RAMDisk implementation for Linux with minimal footprint on your system. Only takes two bash scripts and one service. RAMDisk utilizes `ramfs` with following advantages: 

* Files always reside in RAM and will never interfere with the swap partition.
* RAMDisk dynamically increases in size as more files are added.
  
However, one should monitor the amount of data stored on the RAMDisk and make sure it does not exceed available RAM size. Otherwise system will crash.

How to install
==============

Prerequisites: `rsync`, `systemd` - should be included in the most Linux repositories by default. Open Terminal app and enter following commands:

```
git clone https://github.com/petrstepanov/tiny-ramdisk
chmod +x ./install.sh && install.sh
```

Feel free to open an Issue.
