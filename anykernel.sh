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
supported.patchlevels=2020-02 -
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=1;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel install
dump_boot;

# remove old root patch avoidance hack
patch_cmdline "skip_override" "";

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

write_boot;
flash_dtbo;
## end install

