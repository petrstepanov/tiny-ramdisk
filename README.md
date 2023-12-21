Tiny RAMDisk
============

![Simple Ram Disk Implementatioon for Linux](./resources/tiny-ramdisk.png#gh-light-mode-only)
![Simple Ram Disk Implementatioon for Linux](./resources/tiny-ramdisk-dark.png#gh-dark-mode-only)

Simple persistent RAMDisk implementation for Linux with minimal footprint on your system. Only takes two bash scripts and one service. RAMDisk utilizes `ramfs`.

* Files always reside in RAM and will never interfere with the swap partition.
* RAMDisk dynamically increases in size as more files are added.
* Each user on the system can have his own RAMDisk.

RAMDisk functionality can significantly benefit older computers with slower hard drive speeds. Hard Disk (HDD or SSD) read and write operations are moved to the Random Access Memory (RAM). Therefore depending on the hardware setup of a particular machine, user will experience about 10x productivity boost. This is crucial when working with large projects in Integrated Development Environment (IDEs), running various computational analysis and working with large amounts of data.

IMPORTANT: user is responsible to keep track of the amount of data stored on the RAMDisk. Ensure it does not exceed available RAM size. Otherwise system may have unpredictable behavior.

How to Install
--------------

Prerequisites: `rsync`, `systemd` - should be included in the most Linux repositories by default. Open Terminal app and enter following commands:

```
git clone https://github.com/petrstepanov/tiny-ramdisk
chmod +x ./install.sh && install.sh
```

The RAM disk is mounted in the `RAMDisk` folder in home folder. Upon restart files are saved in the hidden `~/.RAMDisk` folder.

How to Uninstall
----------------

Execute following command inside the program folder:

```
chmod +x ./uninstall.sh && uninstall.sh
```

After uninstalling files are still available under `~/.RAMDisk` directory. 
