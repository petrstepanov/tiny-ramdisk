Tiny Ramdisk
============

Trivial persistent RAMDisk implementation for Linux with minimal footprint on your system. Only takes two bash scripts and one service. RAMDisk utilizes `ramfs` with following advantages: 

* Files always reside in RAM and will never interfere with the swap partition.
* RAMDisk dynamically increases in size as more files are added.
  
However, one should monitor the amount of data stored on the RAMDisk and make sure it does not exceed available RAM size. Otherwise system will crash.

How to Install
--------------

Prerequisites: `rsync`, `systemd` - should be included in the most Linux repositories by default. Open Terminal app and enter following commands:

```
git clone https://github.com/petrstepanov/tiny-ramdisk
chmod +x ./install.sh && install.sh
```

The RAM disk is mounted in the `RAMDisk` folder in home folder. Upon logout files are saved to the `~/.RAMDisk` location.

How to Uninstall
----------------

Execute following command inside the program folder:

```
chmod +x ./uninstall.sh && uninstall.sh
```

After uninstalling files are still available under `~/.RAMDisk` directory. 

P.S. Feel free to open an Issue.
