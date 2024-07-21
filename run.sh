#!/bin/sh
qemu-system-i386 -serial stdio -vga std -m 1096M -drive file=MentOS/rootfs.img,format=raw,index=0,media=disk -kernel MentOS/mentos/bootloader.bin
