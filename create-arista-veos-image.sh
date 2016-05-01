f2e5c759-7d35-4cc0-a406-a03cdbd18297
#!/bin/bash
# create-arista-veos-image.sh
# HS-Fulda - sebastian.rieger@informatik.hs-fulda.de
#
# changelog:
# V1.1   added injection of config defined in VM Maestro using config-drivex
# V1.11  fixed device mapping of extracted partitions, fixed problems with stale swi directory
# V1.12  rc.eos now supports e1000 and virtio as vnic types (virtio is supported in vEOS >=4.14.5F)
# V1.2   added dynamic handling of device mapping of extacted partitions
# V1.21  checking whether it safe to unmount working directories
# V1.3   added support to delete existing image with the same name and generating the default nova flavor
# V1.31  added support for newer glance releases (e.g. kilo) used in VIRL 1.0.0 
# V1.32  changed the extension of the bootloader iso to match the size of the partitions to be injected
# V1.4   support for variable VEOS image sizes (as requested by @Jade_Deane to use custom VEOS images)
# V1.5   automatic import of subtype and creation of flavors based on image name,
#        short instructions on how to use the image and hint to default node configuration,
#        removed detection of existing image as new VIRL version supports multiple versions

# usage
if [ ! $# -eq 3 ] ; then
  echo -e "usage: $0 <Aboot-veos-serial-version.iso> <vEOS-version.vmdk> <new glance image name>, e.g.:\n"
  echo "$0 Aboot-veos-serial-2.0.8.iso vEOS-4.13.4F.vmdk vEOS"
  exit -1
fi

# sudo check
if [ ! $UID -eq 0 ] ; then
  echo "Insufficient privileges. Please consider using sudo -s."
  exit -1
fi

ABOOT_SERIAL_ISO=$1
ABOOT_SERIAL_ISO_BASENAME=$(basename -s .iso $1)
VEOS_VMDK=$2
VEOS_VMDK_BASENAME=$(basename -s .vmdk $2)
GLANCE_IMAGE_NAME=$3
GLANCE_IMAGE_RELEASE=$VEOS_VMDK_BASENAME-$ABOOT_SERIAL_ISO_BASENAME
TMP_NAME="vEOS-$GLANCE_IMAGE_RELEASE"
TIMESTAMP=$(date +%Y%m%d%H%M%S)

function safe_unmount() {
  echo -n "Unmounting $1..."
  RETRY=0
  until umount $1 &>/dev/null
  do
    echo -n "."
    sleep 1
    RETRY=$((RETRY+1))
    if [ "$RETRY" -ge "5" ] ; then
      echo
      echo "ERROR: unable to unmount working directory $1"
      exit 1
    fi
  done
  echo
  return 0
}

echo
echo "Creating vEOS image..."
echo "==========================================================="

# create a copy of Aboot bootloader and extend it to 3G
cp $1 $TMP_NAME.raw

echo
echo "Extracting partitions from vEOS vmdk..."
echo "==========================================================="

# convert vmdk to raw and extract two partitions in it
qemu-img convert -O raw $2 $VEOS_VMDK_BASENAME.raw
LOOPDEV=$(kpartx -av $VEOS_VMDK_BASENAME.raw)
LOOPDEV_PART1=$(echo "$LOOPDEV" | sed '1q;d' | cut -d " " -f 3)
LOOPDEV_PART2=$(echo "$LOOPDEV" | sed '2q;d' | cut -d " " -f 3)
dd if=/dev/mapper/$LOOPDEV_PART1 of=$VEOS_VMDK_BASENAME-p1.raw
dd if=/dev/mapper/$LOOPDEV_PART2 of=$VEOS_VMDK_BASENAME-p2.raw
kpartx -d $VEOS_VMDK_BASENAME.raw

echo
echo "Injecting rc.eos startup script to get switch config..."
echo "==========================================================="

# inject rc.eos script in first partition of the image, to get switch config defined in VM Maestro (config-drive)
mkdir swi-$TIMESTAMP
mount -o loop $VEOS_VMDK_BASENAME-p1.raw swi-$TIMESTAMP
cd swi-$TIMESTAMP
cat << EOF > rc.eos
#!/bin/sh
#
# startup script to get node configs from VM Maestro
#

echo "Getting switch config from config drive..."
echo "=========================================="
mkdir /config-drive
mount /dev/sdb1 /config-drive

echo "Getting ip address for ma1 via dhcp..."
echo "=========================================="
MANAGEMENT_INTERFACE="ma1"
ip link show \$MANAGEMENT_INTERFACE
if [ \$? -ne 0 ]; then
  # if using virtio ma1 will not be up during Eos Init 1, hence we use eth0
  MANAGEMENT_INTERFACE="eth0"
fi
dhclient -r \$MANAGEMENT_INTERFACE
dhclient -1 -v \$MANAGEMENT_INTERFACE >/mnt/flash/dhclient.log
IP=\$(ip addr show \$MANAGEMENT_INTERFACE | grep inet | tr -s ' ' | cut -d ' ' -f 3 | sed s/"\/"/"\\\\\\\\\/"/g)
echo \$IP
sed s/"! ip of ma1 configured on launch"/"ip address \$IP"/g /config-drive/veos_config.txt >/mnt/flash/startup-config.tmp
cat /mnt/flash/startup-config.tmp
echo

echo "Copying switch config from config drive..."
echo "=========================================="
cp /mnt/flash/startup-config.tmp /mnt/flash/startup-config
EOF
chmod 755 rc.eos
cd ..

safe_unmount swi-$TIMESTAMP

rm -rf swi-$TIMESTAMP

echo
echo "Injecting new partitions from vEOS vmdk in Aboot image..."
echo "==========================================================="

# calulate size of the two partitions
PART1_START=$(fdisk -l $VEOS_VMDK_BASENAME.raw | grep "\.raw1" | tr -s " " | cut -d ' ' -f 3)
PART1_END=$(fdisk -l $VEOS_VMDK_BASENAME.raw | grep "\.raw1" | tr -s " " | cut -d ' ' -f 4)
PART1_LENGTH=$(expr $PART1_END - $PART1_START)

PART2_START=$(fdisk -l $VEOS_VMDK_BASENAME.raw | grep "\.raw2" | tr -s " " | cut -d ' ' -f 2)
PART2_END=$(fdisk -l $VEOS_VMDK_BASENAME.raw | grep "\.raw2" | tr -s " " | cut -d ' ' -f 3)
PART2_LENGTH=$(expr $PART2_END - $PART2_START)

# extend the bootloader iso to be able to append the two partitions
EXTENSION_SIZE=$(ls -lk $VEOS_VMDK_BASENAME.raw | tr -s " " | cut -d " " -f 5)
truncate -s +$EXTENSION_SIZE $TMP_NAME.raw

# append the two partitions from vmdk in the bootloader iso
echo -e "n
p


+$PART1_LENGTH
t
2
c
a
2
n
p


+$PART2_LENGTH
t
3
12
w" | fdisk $TMP_NAME.raw >/dev/null

# copy the partitions from vEOS vmdk to new image
LOOPDEV=$(kpartx -av $TMP_NAME.raw)
LOOPDEV_PART2=$(echo "$LOOPDEV" | sed '2q;d' | cut -d " " -f 3)
LOOPDEV_PART3=$(echo "$LOOPDEV" | sed '3q;d' | cut -d " " -f 3)
dd if=$VEOS_VMDK_BASENAME-p1.raw of=/dev/mapper/$LOOPDEV_PART2
dd if=$VEOS_VMDK_BASENAME-p2.raw of=/dev/mapper/$LOOPDEV_PART3
kpartx -d $TMP_NAME.raw

echo
echo "Convert new image to qcow2..."
echo "==========================================================="

# convert raw to qcow2
qemu-img convert -O qcow2 $TMP_NAME.raw $TMP_NAME.qcow2

echo
echo "Cleaning up..."
echo "==========================================================="

#cleanup
rm $TMP_NAME.raw
rm $VEOS_VMDK_BASENAME-p1.raw
rm $VEOS_VMDK_BASENAME-p2.raw
rm $VEOS_VMDK_BASENAME.raw

echo
echo "Importing image into glance..."
echo "==========================================================="
glance image-create --container-format bare --disk-format qcow2 --visibility public --name $GLANCE_IMAGE_NAME \
  --file $TMP_NAME.qcow2 --property hw_disk_bus=ide --property serial=1 \
  --property hw_vif_model=e1000 --property hw_cdrom_type=ide --property release="$GLANCE_IMAGE_RELEASE" --property subtype=IOSv --property config_disk_type=disk

# create default flavor
CHECKING_FOR_EXISTING_FLAVOR=$(nova flavor-show vEOS.small 2>&1)
if [ $? == 1 ]; then
  echo "Creating default flavor vEOS.small..."
  echo "==========================================================="

  nova flavor-create --is-public true vEOS.small auto 1024 0 1
fi
CHECKING_FOR_EXISTING_FLAVOR=$(nova flavor-show $GLANCE_IMAGE_NAME.medium 2>&1)
if [ $? == 1 ]; then
  echo "Creating default flavor $GLANCE_IMAGE_NAME.medium..."
  echo "==========================================================="

  nova flavor-create --is-public true $GLANCE_IMAGE_NAME.medium auto 2048 0 1
fi

CHECKING_FOR_EXISTING_FLAVOR=$(nova flavor-show $GLANCE_IMAGE_NAME.small 2>&1)
if [ $? == 1 ]; then
  echo "Creating default flavor $GLANCE_IMAGE_NAME.small..."
  echo "==========================================================="

  nova flavor-create --is-public true $GLANCE_IMAGE_NAME.small auto 1024 0 1
fi

#CHECKING_FOR_EXISTING_SUBTYPE=$(virl_uwm_client subtype-export 2>/dev/null | grep -Po '"'"plugin_desc"'"\s*:\s*"\K([^"]*)')
CHECKING_FOR_EXISTING_SUBTYPE=$(virl_uwm_client subtype-export 2>/dev/null | grep "\"plugin_name\": \"$GLANCE_IMAGE_NAME\",")
if [ $? == 1 ]; then
  # create default subtype
  cat << EOF > $TIMESTAMP.default-subtype
{
  "dynamic-subtypes": [
    {
      "interface_range": 22, 
      "config_disk_type": "disk", 
      "baseline_image": "$GLANCE_IMAGE_NAME", 
      "baseline_flavor": "$GLANCE_IMAGE_NAME.medium", 
      "hw_vm_extra": "", 
      "plugin_desc": "Arista vEOS", 
      "interface_pattern": "Ethernet{0}", 
      "interface_management": "Management1", 
      "gui_visible": true, 
      "cli_serial": 1, 
      "hw_ram": 1024, 
      "plugin_name": "$GLANCE_IMAGE_NAME", 
      "interface_first": 1, 
      "config_file": "/veos_config.txt", 
      "gui_icon": "iosvl2", 
      "plugin_base": "generic"
    }
  ]
}
EOF
  
  echo "Creating default subtype vEOS..."
  echo "==========================================================="

  virl_uwm_client subtype-import --dynamic-subtypes @$TIMESTAMP.default-subtype
  
  rm $TIMESTAMP.default-subtype
fi

echo
echo "Creation of the image finished successfully"
echo "==========================================================="

echo "You can import the default Subtype in VM Maestro using"
echo "\"File->Preferences->Node Subtypes->Restore Defaults\""
echo "followed by clicking on \"Fetch from Server\". Afterwards,"
echo "vEOS should appear in the \"Nodes\" section of VM Maestro's"
echo "Topology Palette. The following default config can be used"
echo "by pasting it into the Configuration tab after clicking on"
echo "each vEOS node created in your topology:"

echo -e "
! device: veos-1 (vEOS, EOS-4.14.2F)
!
! boot system flash:/vEOS.swi
!
transceiver qsfp default-mode 4x10G
!
hostname veos-1
!
spanning-tree mode mstp
!
no aaa root
!
username admin role network-admin secret 5 \$1\$93LlZesx\$MSqS1D/8NGTSY724FGx1K0
username cisco role network-admin secret 5 \$1\$rQS0W9wP\$ZUzVG2XoGCCZCJopFp1aV/
!
interface Ethernet1
!
interface Ethernet2
!
interface Management1
  ! ip of ma1 configured on launch
!
no ip routing
!
!
"

echo "Of course you must modify the config (name, version) to your needs."
echo "Otherwise, vEOS will will start with an empty configuration and"
echo "go into Zero-Touch-Provisioning (ZTP) mode. You should also disable"
echo "\"Auto-generate the configuration based on these attributes\" in"
echo "the AutoNetkit tab of the node, as AutoNetkit is only supported"
echo "for the Cisco images in VIRL."     

#testing:
#
#  nova boot --image "Arista vEOS Disk" --flavor m1.small veos --nic net-id=abc7ad47-55fd-4396-8d31-91dd4d41a18a --nic net-id=abc7ad47-55fd-4396-8d31-91dd4d41a18a --nic net-id=abc7ad47-55fd-4396-8d31-91dd4d41a18a --nic net-id=abc7ad47-55fd-4396-8d31-91dd4d41a18a --nic net-id=abc7ad47-55fd-4396-8d31-91dd4d41a18a
#
#  using VM Maestro, the image can be chosen as "VM image", e.g., for an IOSv or IOSvL2 node
