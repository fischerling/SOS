qemu\qemu-system-i386 -L qemu\pc-bios -serial stdio -vga std -m 1096M -drive file=MentOS\rootfs.img,format=raw,index=0,media=disk -kernel MentOS\mentos\bootloader.bin
