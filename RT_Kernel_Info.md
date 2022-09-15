**Way to compile RT Kernel on RaspBerry 3/4 - takes long time**  

http://robskelly.com/2020/10/14/raspberry-pi-4-with-64-bit-os-and-preempt_rt/  
https://www.raspberrypi.com/documentation/computers/linux_kernel.html  
https://www.instructables.com/64bit-RT-Kernel-Compilation-for-Raspberry-Pi-4B-/  

sudo apt install git bc bison flex libssl-dev make  

git clone --depth=1 --branch rpi-5.15.y https://github.com/raspberrypi/linux  

wget https://mirrors.edge.kernel.org/pub/linux/kernel/projects/rt/5.15/older/patch-5.15.55-rt48.patch.gz  

cd linux  
zcat patch-5.15.55-rt48.patch.gz | patch -p1  

KERNEL=kernel8  
make bcm2711_defconfig  

make menuconfig ## Remove Virtualization ## AD RT kernel  

nano kernel/shed/deadline.o  

STRG+W and find: printk_deferred_once  
Replace with: printk_once  

nano .config  
STRG+W and find: CONFIG_LOCALVERSION="-v7l-MY_CUSTOM_KERNEL"  
Add own description of kernel  

make -j4 Image.gz modules dtbs	##compile  
**install modules and kernel**

KERNEL=kernel8
sudo make modules_install dtbs_install
sudo cp arch/arm64/boot/dts/broadcom/*.dtb /boot/
sudo cp arch/arm64/boot/dts/overlays/*.dtb* /boot/overlays/
sudo cp arch/arm64/boot/dts/overlays/README /boot/overlays/
sudo cp arch/arm64/boot/Image.gz /boot/$KERNEL.img
