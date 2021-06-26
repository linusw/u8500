#!/bin/bash

BASEDIR="/home/hd-/job"
INITRAMFSDIR="$BASEDIR/initramfs"

echo "HD Kernel"
sleep 3

echo "Building HD Kernel"

echo "Clean up Source"

make clean mrproper
rm ../myfile/kernel.bin.md5
rm ../myfile/*.txt
rm ../myfile/*.tar.md5

echo "Exporting defconfig"
make hd_defconfig
echo "Build Version : $1"

echo "Compiling Kernel"

make -j9

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
