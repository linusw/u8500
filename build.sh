#!/bin/bash

BASEDIR="/home/hd-/job"
INITRAMFSDIR="$BASEDIR/initramfs"

echo "HD Kernel"
sleep 3

echo "Building HD Kernel"

echo "Clean up Source"

make clean mrproper
rm -rf ${INITRAMFSDIR}/lib/modules/2.6.35.7/fs
rm -rf ${INITRAMFSDIR}/lib/modules/2.6.35.7/kernel
rm ../myfile/kernel.bin.md5
rm ../myfile/*.txt
rm ../myfile/*.tar.md5

echo "Exporting defconfig"
make hd_defconfig
echo "Build Version : $1"

echo "Compiling Kernel"

make -j9

echo "Compiling Modules"

make -j9 modules

echo "Copy modules to initramfs"

		echo -e "\n\n Copying Modules to InitRamFS Folder...\n\n"
		mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/fs
		mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/fs/cifs
		mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/kernel
		mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/bluetooth/bthid
		mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/net/wireless/bcm4330
		mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/samsung/j4fs
		mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/samsung/param
		mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/scsi
		#mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/fs/cifs

		cp fs/cifs/cifs.ko $INITRAMFSDIR/lib/modules/2.6.35.7/fs/cifs/cifs.ko
		cp drivers/bluetooth/bthid/bthid.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/bluetooth/bthid/bthid.ko
		cp drivers/net/wireless/bcm4330/dhd.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/net/wireless/bcm4330/dhd.ko
		cp drivers/samsung/param/param.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/samsung/param/param.ko
		cp drivers/scsi/scsi_wait_scan.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/scsi/scsi_wait_scan.ko
		#cp drivers/samsung/j4fs/j4fs.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/samsung/j4fs/j4fs.ko

		cp $BASEDIR/stock-modules/j4fs.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/samsung/j4fs/j4fs.ko
		#cp $BASEDIR/stock-modules/bthid.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/bluetooth/bthid/bthid.ko
		#cp $BASEDIR/stock-modules/dhd.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/net/wireless/bcm4330/dhd.ko
		#cp $BASEDIR/stock-modules/param.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/samsung/param/param.ko
		#cp $BASEDIR/stock-modules/scsi_wait_scan.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/scsi/scsi_wait_scan.ko

cd ../initramfs/lib/modules/2.6.35.7
echo "Strip modules for size"

for m in $(find . | grep .ko | grep './')
do
	echo $m

/home/hd-/Toolchains/arm-aebi-linaro-4.4/bin/arm-eabi-strip --strip-unneeded $m
done

cd ~/job/kernel

echo "initramfs ready!"

echo "Building zImage"
make -j9 zImage


echo "Setting up zImage for I8160"

cp arch/arm/boot/zImage ../myfile/zImage

cd ../myfile

mv zImage kernel.bin
md5sum -t kernel.bin >> kernel.bin
mv kernel.bin kernel.bin.md5
md5sum kernel.bin.md5 > md5sum_HD$1.txt
tar cf HD-GT-I8160-TWRP-Kernel.V1.0.1.tar kernel.bin.md5
md5sum -t HD-GT-I8160-TWRP-Kernel.V1.0.1.tar >> HD-GT-I8160-TWRP-Kernel.V1.0.1.tar
mv HD-GT-I8160-TWRP-Kernel.V1.0.1.tar HD-GT-I8160-TWRP-Kernel.V1.0.1.tar.md5

echo "md5sum is-"

cat md5sum_HD$1.txt

echo "all done"
