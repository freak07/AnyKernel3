# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Kirisakura-Kernel by Freak07 @ xda-developers
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=crosshatch
device.name2=blueline
supported.versions=10
supported.patchlevels=2019-04 -
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=1;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel install
split_boot;

# use custom kernel compression
kernel_compression=lz4;
kernel_comp_ext=lz4;

# combine kernel image and dtbs if separated in the zip
decompressed_image=$home/kernel/Image;
compressed_image=$decompressed_image.$kernel_comp_ext;
combined_image=$home/Image.$kernel_comp_ext-dtb;
if [ -f $compressed_image ]; then
  # hexpatch the kernel if Magisk is installed ('skip_initramfs' -> 'want_initramfs')
  if ! $bin/magiskboot cpio $split_img/ramdisk.cpio test; then
    ui_print " " "Magisk detected! Patching kernel so reflashing Magisk is not necessary...";
    $bin/magiskboot --decompress $compressed_image $decompressed_image;
    $bin/magiskboot --hexpatch $decompressed_image 736B69705F696E697472616D667300 77616E745F696E697472616D667300;
    $bin/magiskboot --compress=$kernel_compression $decompressed_image $compressed_image;
  fi;
  if [ -d $home/dtbs ]; then
    cat $compressed_image $home/dtbs/*.dtb > $combined_image;
  fi;
fi;

# patch kernel dtb and/or dtbo on custom ROMs
if [ -f $combined_image -o -f $home/dtbo.img ]; then
  user=$(file_getprop /system/build.prop ro.build.user);
  echo "Found user: $user";
  case $user in
    android-build) ;;
    *) custom=1;;
  esac;
  host=$(file_getprop /system/build.prop ro.build.host);
  echo "Found host: $host";
  case $host in
    *corp.google.com|abfarm*) ;;
    *) custom=1;;
  esac;
  if [ "$custom" ]; then
    ui_print " " "You are on a custom ROM, patching dtb and/or dtbo to remove verity...";
    for dtb in $combined_image $home/dtbo.img; do
      test -f $dtb && $bin/magiskboot --dtb-patch $dtb;
    done;
  else
    ui_print " " "You are on stock, not patching dtb and/or dtbo to remove verity!";
  fi;
fi;

flash_boot;
flash_dtbo;
## end install

