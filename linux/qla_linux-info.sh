#! /bin/bash
#
#####################################################################
# This script attempts to gather troubleshooting information on 
# a variety of Linux hosts.  Files that exist in one distribution of
# Linux may not exist in another distribution (SuSE vs Red Hat).
# Please ignore any errors reported about files not existing.
#
# --QLogic Technical Support
#
#####################################################################
#
ScriptVER="4.14.02"
#
#####################################################################

# So users can run the script using su or sudo
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:$PATH

# Constants 
#-----------

# Maximum file size when gathering system files
#----------------------------------------------
LARGEFILE=2000000

# Q install directory
#--------------------
QHOME=/opt/QLogic_Corporation


# check for root permissions
#---------------------------
if [ `id -u` -ne 0 ]
then
   echo "This script must be run with root permissions.  Please rerun as root or with sudo."
   exit
fi


# Check for command line switch (z,Z,-z,-Z) for
# gathering of large system files/directories          
#----------------------------------------------
case $1 in

  z)
     GETFILES=1
     ;;
  Z)
     GETFILES=1
     ;;
  -z)
     GETFILES=1
     ;;
  -Z)
     GETFILES=1
     ;;
  "")
     GETFILES=0
     ;;
  *)
     echo "Usage: Copy system directories/files        : \"qla-linux_info.sh -z\""
     echo "       Do not copy system directories/files : \"qla-linux_info.sh\""
     exit
     ;;
esac

# Create root of output bundle 
#-----------------------------
CurDate=`/bin/date +%y%m%d_%H%M%S`
HostName=`uname -n`
LOGNAME="$HostName-$CurDate"
LOGDIR="/tmp/$LOGNAME"
echo "Script starting"
echo "Log data will be stored in $LOGDIR"
echo "Output results will be tar-zipped to $LOGDIR.tgz"
echo ""
mkdir $LOGDIR
mkdir $LOGDIR/script
cd $LOGDIR
touch $LOGDIR/script/ScriptVersion.$ScriptVER
mkdir $LOGDIR/OS

# logger entry to identify start of script
#-----------------------------------------
which logger > /dev/null 2>&1
if [ $? -eq 0 ]
then
   logger "qla_linux_info.sh starting with PID $$"
fi

#-----------------------
echo "Collecting Data"
echo ""

# Gather OS info 
#-------------------
# paths, variables, & directories needed early in the script 
mkdir $LOGDIR/modules
lsmod  > $LOGDIR/modules/lsmod.out 2>&1


# OS release & version
#---------------------

UBUNTU=0
XEN=0
SLES=0

echo -n "Gathering OS release & version info "
OS_FILES=`ls /etc/*-release /etc/*_version 2>> $LOGDIR/script/misc_err.log`
for file in $OS_FILES
do
   if [ -f $file ]
   then
      cp -p $file $LOGDIR/OS
   fi
done

if [ -f $LOGDIR/OS/redhat-release ]
then
   OSNAME=`cat $LOGDIR/OS/redhat-release`
   if [ -f $LOGDIR/OS/rocks-release ]
   then
      OSNAME="$OSNAME / `cat $LOGDIR/OS/rocks-release`"
   fi
   TSTNM=`cat $LOGDIR/OS/redhat-release | cut -d " " -f 1`
   if [[ $TSTNM = XenServer ]]
   then
      XEN=1
   fi
elif [ -f $LOGDIR/OS/SuSE-release ]
then
   OSNAME=`grep -i suse $LOGDIR/OS/SuSE-release`
   OSVER=`grep VERSION $LOGDIR/OS/SuSE-release`
   OSPATCH=`grep -h PATCH $LOGDIR/OS/*release`
   SLES=1
elif [ -f $LOGDIR/OS/os-release ]
then
   OSNAME=`grep PRETTY $LOGDIR/OS/os-release | cut -d \" -f 2`
   UBUNTU=1
else
   OSNAME="unknown"
fi

# Files that could be useful if we need to duplicate the host install
#--------------------------------------------------------------------
if [ -f /root/anaconda-ks.cfg ]
then
   cp /root/anaconda-ks.cfg $LOGDIR/OS
fi
if [ -f /root/autoinst.xml ]
then
   cp /root/autoinst.xml $LOGDIR/OS
fi
last > $LOGDIR/OS/last.out
echo "... done"

# multipath
#----------
echo -n "Checking multipath: "
if command -v multipathd > /dev/null 2>&1; then
   multipathd show config > $LOGDIR/OS/multipathd-config 2>&1
   multipath -ll > $LOGDIR/OS/multipath-ll 2>&1
else
   echo "multipathd not found in search path" > $LOGDIR/OS/multipathd-config 2>&1
fi
echo "... done"
   
# system
#-------
echo -n "Get system & cpu "
dmidecode -t processor > $LOGDIR/OS/dmidecode-processor 2>&1
dmidecode -t system > $LOGDIR/OS/dmidecode-system 2>&1
echo "... done"

echo -n "Checking what's installed "
if [[ $UBUNTU -eq 1 ]]
then
   dpkg-query -l > $LOGDIR/OS/dpkg-list.out
else
   rpm -qa  > $LOGDIR/OS/rpm_list.out
   rpm -qa --queryformat "[%-25{NAME} %{FILENAMES} %{FILESIZES}\n]" > /$LOGDIR/OS/rpm_detailed.out
fi
   uname -a > $LOGDIR/OS/uname
echo "... done"

# Specific data from /sys directory
#----------------------------------
if [ -d /sys ]
then
   echo -n "Gathering /sys data " 
   ls -alRF /sys > $LOGDIR/OS/ls_sys.out
   mkdir $LOGDIR/sys
   mkdir $LOGDIR/sys/class
   mkdir $LOGDIR/sys/class/scsi_host
   mkdir $LOGDIR/sys/class/fc_host
   mkdir $LOGDIR/sys/class/iscsi_host
   mkdir $LOGDIR/sys/class/net
   cp -pR /sys/class/scsi_host/*/      $LOGDIR/sys/class/scsi_host      2>  $LOGDIR/sys/copy_err.log
   cp -pR /sys/class/fc_host/*/        $LOGDIR/sys/class/fc_host        2>> $LOGDIR/sys/copy_err.log
   cp -pR /sys/class/iscsi_host/*/     $LOGDIR/sys/class/iscsi_host     2>> $LOGDIR/sys/copy_err.log
   cp -pR /sys/class/net/*/            $LOGDIR/sys/class/net            2>> $LOGDIR/sys/copy_err.log

   mkdir -p $LOGDIR/sys/module
   cp -pR /sys/module/scsi*            $LOGDIR/sys/module 2>> $LOGDIR/sys/copy_err.log
   cp -pR /sys/module/qis*             $LOGDIR/sys/module 2>> $LOGDIR/sys/copy_err.log
   cp -pR /sys/module/qla*             $LOGDIR/sys/module 2>> $LOGDIR/sys/copy_err.log
   cp -pR /sys/module/qlge             $LOGDIR/sys/module 2>> $LOGDIR/sys/copy_err.log
   cp -pR /sys/module/qlcnic           $LOGDIR/sys/module 2>> $LOGDIR/sys/copy_err.log
   cp -pR /sys/module/ixgbe            $LOGDIR/sys/module 2>> $LOGDIR/sys/copy_err.log
   cp -pR /sys/module/nx_nic           $LOGDIR/sys/module 2>> $LOGDIR/sys/copy_err.log
   cp -pR /sys/module/netxen_nic       $LOGDIR/sys/module 2>> $LOGDIR/sys/copy_err.log
   cp -pR /sys/module/8021q            $LOGDIR/sys/module 2>> $LOGDIR/sys/copy_err.log
   cp -pR /sys/module/bonding          $LOGDIR/sys/module 2>> $LOGDIR/sys/copy_err.log
   echo "... done"
fi

# Clone system directory/file structure - optional (cl switch = -z)
#------------------------------------------------------------------
if [ $GETFILES -eq 1 ]
then
   echo "Gathering system directories/files (this could take several minutes): "
   NODATA=0
   SYSFILES=$LOGDIR/OS/system-dirs

   mkdir $SYSFILES

   DIRS="/var/lib/lldpad \
   /var/lib/iscsi \
   /var/log \
   /var/core \
   /etc/iscsi \
   /etc/fcoe \
   /etc/sysconfig \
   /etc/rc.d \
   /etc/init.d \
   /boot \
   /sys \
   /proc/sg \
   /proc/sys/kernel \
   /proc/sys/net \
   /proc/sys/vm "

   for dir in $DIRS
   do
      if [ -d $dir ]
      then
         echo "... working"
         if [ $dir == \/sys ]
         then
            echo "...... very long delay"
         fi
         ls -lR $dir> /tmp/ls.out
         while read line
         do
            if [[ $line == /* ]]                        # Does $line begin with a "/"?
            then
               DIRLN=(${#line}-1)                       # Backup 1 place from the ":" at the end of the line 
               CURDIR=${line:0:$DIRLN}                  # Initialize CURDIR 
               FULPTH=`echo ${CURDIR//\// }`            # Replace all occurances of "/" with " "
               FULPTH=( $FULPTH )                       # Re-cast the string $FULPTH as an array
               CNT=`echo ${#FULPTH[@]}`                 # Count the initialized elements in the FULPTH array
               CNT=$[$CNT-1]                            # Array indeceis start @ 0
               cntr=0
               NXTPTH=$SYSFILES                         
               while [ $cntr -le $CNT ]
               do
                  NXTDIR=`echo ${FULPTH[@]:$cntr:1}`    # Initialize 'NXTDIR' to 'FULPTH[cntr]'
                  NXTPTH=$NXTPTH\/$NXTDIR             
                  cntr=$[$cntr+1]
                  if [[ ! -d ${NXTPTH} ]]
                  then
                     mkdir $NXTPTH
                  fi
               done
            elif [[ $line == lrw* ]]
            then
               FILE=`echo $line | cut -d" " -f9`        
               cp -d $CURDIR/$FILE $NXTPTH/$FILE 2>> $SYSFILES/copy_err.log
            elif [[ $line == -* && $line != --w-* ]]    # $line is not a directory, and not owner write only
            then
               FILE=`echo $line | cut -d" " -f9`        
               FILESIZ=`echo $line | cut -d" " -f5`    
               if [[ $FILESIZ -gt $NODATA ]]
               then
                  if [[ $FILESIZ -le $LARGEFILE ]]
                  then
                     cp  $CURDIR/$FILE $NXTPTH/$FILE 2>> $SYSFILES/copy_err.log    
                  else
                     if [[ ! -d $NXTPTH/Skipped_Large_Files ]]  
                     then
                        mkdir $NXTPTH/Skipped_Large_Files        
                     fi
                     touch $NXTPTH/Skipped_Large_Files/$FILE
                  fi
               fi
            fi
         done < /tmp/ls.out
      fi
   done
   rm /tmp/ls.out
   echo "... done"
fi

echo -n "Gathering PCIe info "
mkdir $LOGDIR/misc
lspci                   > $LOGDIR/misc/lspci.out
lspci -v                > $LOGDIR/misc/lspci-v.out 2>&1
lspci -vvv              > $LOGDIR/misc/lspci-vvv.out 2>&1
lspci -vvvxxx           > $LOGDIR/misc/lspci-vvvxxx.out 2>&1
lspci -vmm 		> $LOGDIR/misc/lspci-vmm.out 2>&1
lspci -vnn              > $LOGDIR/misc/lspci-vnn.out 2>&1
echo "... done"

if hash fcoeadm 2>/dev/null;
then
   echo -n "Gathering FCoE information "
   mkdir $LOGDIR/FCoE
   fcoeadm -i > $LOGDIR/FCoE/fcoeadm-i 2>&1
   fcoeadm -t > $LOGDIR/FCoE/fcoeadm-t 2>&1
   fcoeadm -l > $LOGDIR/FCoE/fcoeadm-l 2>&1
   echo "... done"
fi
 
echo -n "Gathering miscellaneous system info "
uptime                 > $LOGDIR/misc/uptime.out 2>&1
dmidecode              >  $LOGDIR/misc/dmidecode.out 2>&1
fdisk -l               >  $LOGDIR/misc/fdisk.out 2>&1
ps -ewf                >  $LOGDIR/misc/ps.out
top -bH -n 1           >  $LOGDIR/misc/top.out 2>&1

ls -lF /usr/bin/*gcc*  >  $LOGDIR/misc/gcc.out 2>&1
echo "========"   >> $LOGDIR/misc/gcc.out
gcc --version          >> $LOGDIR/misc/gcc.out 2>&1

ldconfig -p            >  $LOGDIR/misc/ldconfig.out 2>&1
who -r                 >  $LOGDIR/misc/who_r.out 2>&1
runlevel               >  $LOGDIR/misc/runlevel.out 2>&1
env                    >  $LOGDIR/misc/env.out 2>&1
chkconfig --list       >  $LOGDIR/misc/chkconfig.out 2>&1
ls -alRF /usr/lib/     >  $LOGDIR/misc/ls_usrlib.out
if [ -d /usr/lib64 ]
then
   ls -alRF /usr/lib64/>  $LOGDIR/misc/ls_usrlib64.out
fi
#which lsscsi > /dev/null 2>&1
#if [ $? -eq 0 ]
#then
#   lsscsi              >  $LOGDIR/misc/lsscsi.out 2>&1
#   lsscsi --verbose    >  $LOGDIR/misc/lsscsi_verbose.out 2>&1
#fi
sysctl -a              >  $LOGDIR/misc/sysctl.out 2>&1
lsof                   >  $LOGDIR/misc/lsof.out 2>&1
vmstat -a              >  $LOGDIR/misc/vmstat.out 2>&1
free                   >  $LOGDIR/misc/free.out 2>&1
ulimit -a              >  $LOGDIR/misc/ulimit.out 2>&1
echo "... done"

echo -n "Checking for installed adapters "
NXTINSTALLED=0
BRINSTALLED=0
QINSTALLED=0
FCAINSTALLED=0
FCINSTALLED=0
FCCONFLICT=0
ISCSIINSTALLED=0
ETHERINSTALLED=0
FASTLINQINSTALLED=0

# NetExtreme adapter
#-----------------------------
if grep -q 'Broadcom' $LOGDIR/misc/lspci-v.out
then
   if grep -q 'bnx' $LOGDIR/modules/lsmod.out
   then
      NXTINSTALLED=1
      mkdir $LOGDIR/NetXtreme
   fi
fi

# BR series adapter
#--------------------------
if grep -q 'Brocade' $LOGDIR/misc/lspci-v.out
then 
   if grep -q 'bfa' $LOGDIR/modules/lsmod.out
   then
      BRINSTALLED=1
      mkdir $LOGDIR/BR
   fi
fi 

# For the QLE10000
#-----------------
TESTHBA=`grep QLogic $LOGDIR/misc/lspci-v.out|grep "Fibre Channel:" | grep f001`
if [ -n "$TESTHBA" ]
then
   FCAINSTALLED=1
   QINSTALLED=1
   mkdir -p $LOGDIR/fca
fi

# Check to see if both an FC & QLE10000 are installed in the same machine
#-------------------------------------------------------------------------
TESTHBA=`grep QLogic $LOGDIR/misc/lspci-v.out|grep "Fibre Channel:" | grep -v f001`
if [ -n "$TESTHBA" -a $FCAINSTALLED -eq 0 ]
then
   FCINSTALLED=1
   QINSTALLED=1
elif [ -n "$TESTHBA" -a $FCAINSTALLED -eq 1 ]
then 
   FCCONFLICT=1
   FCINSTALLED=1
   QINSTALLED=1
fi
#

TESTHBA=`grep QLogic $LOGDIR/misc/lspci-v.out|grep "Network controller:"`
if [ -n "$TESTHBA" ]
then
   ISCSIINSTALLED=1
   QINSTALLED=1
fi

TESTHBA=`grep QLogic $LOGDIR/misc/lspci-v.out|grep "Ethernet controller:"`
if [ -n "$TESTHBA" ]
then
   ETHERINSTALLED=1
   QINSTALLED=1
fi

# QLE8042 uses Intel NIC - report only if FC Installed
TESTHBA=`grep "Intel Corporation 82598" $LOGDIR/misc/lspci-v.out|grep "Ethernet controller:"`
if [ -n "$TESTHBA" -a $FCINSTALLED -eq 1 ]
then
   ETHERINSTALLED=1
   QINSTALLED=1
fi

# E4 (FastLinQ Ethernet adapters)
TESTHBA=`grep "FastLinQ" $LOGDIR/misc/lspci-vvvxxx.out|grep "Ethernet controller:"`
if [ -n "$TESTHBA" ]
then
   FASTLINQINSTALLED=1
   QINSTALLED=1
   mkdir $LOGDIR/fastlinq
fi

echo "... done"
# end of installed adapter check

#echo -n "Gathering miscellaneous system info: "
#uptime                 > $LOGDIR/misc/uptime.out 2>&1
#dmidecode              >  $LOGDIR/misc/dmidecode.out 2>&1
#fdisk -l               >  $LOGDIR/misc/fdisk.out 2>&1
#ps -ewf                >  $LOGDIR/misc/ps.out
#top -bH -n 1           >  $LOGDIR/misc/top.out 2>&1
#
#ls -lF /usr/bin/*gcc*  >  $LOGDIR/misc/gcc.out 2>&1
#echo "========"   >> $LOGDIR/misc/gcc.out
#gcc --version          >> $LOGDIR/misc/gcc.out 2>&1
#
#ldconfig -p            >  $LOGDIR/misc/ldconfig.out 2>&1
#who -r                 >  $LOGDIR/misc/who_r.out 2>&1
#runlevel               >  $LOGDIR/misc/runlevel.out 2>&1
#env                    >  $LOGDIR/misc/env.out 2>&1
#chkconfig --list       >  $LOGDIR/misc/chkconfig.out 2>&1
#ls -alRF /usr/lib/     >  $LOGDIR/misc/ls_usrlib.out
#if [ -d /usr/lib64 ]
#then
#   ls -alRF /usr/lib64/>  $LOGDIR/misc/ls_usrlib64.out
#fi
##which lsscsi > /dev/null 2>&1
##if [ $? -eq 0 ]
##then
##   lsscsi              >  $LOGDIR/misc/lsscsi.out 2>&1
##   lsscsi --verbose    >  $LOGDIR/misc/lsscsi_verbose.out 2>&1
##fi
#sysctl -a              >  $LOGDIR/misc/sysctl.out 2>&1
#lsof                   >  $LOGDIR/misc/lsof.out 2>&1
#vmstat -a              >  $LOGDIR/misc/vmstat.out 2>&1
#free                   >  $LOGDIR/misc/free.out 2>&1
#ulimit -a              >  $LOGDIR/misc/ulimit.out 2>&1
#echo "... done?

#####################################################################
# Gather /etc data
#####################################################################
echo -n "Gathering /etc files "
mkdir $LOGDIR/etc
mkdir $LOGDIR/etc/sysconfig
ETC_FILES="/etc/modules.* \
/etc/modprobe.* \
/etc/qla*.conf \
/etc/hba.conf \
/etc/sysconfig/kernel \
/etc/sysconfig/hwconf \
/etc/sysctl.conf \
/etc/mtab \
/etc/fstab"

for file in $ETC_FILES
do
   if [ -f $file ]
   then
      cp -p $file $LOGDIR/$file
   fi
done

if [ -d /etc/modprobe.d ]
then
   ls -alRF /etc/modprobe.d > $LOGDIR/etc/ls_etc_modprobed.out
   mkdir $LOGDIR/etc/modprobe.d
   MODPROBE_FILES="/etc/modprobe.d/qlhba.conf \
   /etc/modprobe.d/ib_ipoib.conf \
   /etc/modprobe.d/scsi_mod.conf \
   /etc/modprobe.d/qla2xxx.conf \
   /etc/modprobe.d/qla3xxx.conf \
   /etc/modprobe.d/qla4xxx.conf \
   /etc/modprobe.d/nx_nic.conf \
   /etc/modprobe.d/qlge.conf \
   /etc/modprobe.d/modprobe.conf \
   /etc/modprobe.d/blacklist.conf"
   for file in $MODPROBE_FILES
   do
      if [ -f $file ]
      then
         cp -p $file $LOGDIR/$file
      fi
   done

fi

ls -aldF /etc/rc*    > $LOGDIR/etc/ls_etcrcd.out
if [[ $UBUNTU -eq 0 ]]
then
   ls -alRF /etc/rc.d/ >> $LOGDIR/etc/ls_etcrcd.out
fi
echo "... done"



#####################################################################
# Gather /proc data
#####################################################################
mkdir $LOGDIR/proc
mkdir -p $LOGDIR/proc/bus/pci
mkdir $LOGDIR/proc/driver
mkdir $LOGDIR/proc/irq
mkdir $LOGDIR/proc/scsi
mkdir -p $LOGDIR/proc/sys/dev/scsi

echo -n "Gathering /proc files "
PROC_FILES="/proc/modules \
/proc/cmdline \
/proc/cpuinfo \
/proc/devices \
/proc/diskstats \
/proc/interrupts \
/proc/iomem \
/proc/ioports \
/proc/kallsyms \
/proc/locks \
/proc/meminfo \
/proc/modules \
/proc/mounts \
/proc/mtrr \
/proc/pagetypeinfo \
/proc/partitions \
/proc/schedstat \
/proc/slabinfo \
/proc/stat \
/proc/swaps \
/proc/timer_list \
/proc/uptime \
/proc/version \
/proc/vmallocinfo \
/proc/vmstat \
/proc/zoneinfo \
/proc/bus/pci/devices \
/proc/driver/rtc \
/proc/irq/default_smp_affinity \
/proc/scsi/scsi \
/proc/scsi/device_info \
/proc/sys/dev/scsi/logging_level \
/proc/pci \
/proc/buddyinfo \
/proc/ksyms \
/proc/partitions \
/proc/mtrr \
/proc/filesystems \
/proc/ioports \
/proc/iba" 

for file in $PROC_FILES
do
   if [ -f $file ]
   then
      cp -p $file $LOGDIR/$file
   fi
done

# Make sure /proc/scsi directory exists before gathering data
if [ -d /proc/scsi ]
then
   cd $LOGDIR/proc
   cp -pR /proc/scsi $LOGDIR/proc
   cd $LOGDIR
fi

# Gather power management info - performance issues
if [ -d /proc/acpi/processor ]
then
   mkdir -p $LOGDIR/proc/acpi/processor
   cp -pR /proc/acpi/processor/* $LOGDIR/proc/acpi/processor
fi

# Gather network info for FCoE and Netxen
if [ $ETHERINSTALLED -eq 1 ]
then
   mkdir $LOGDIR/proc/net
   # Make sure /proc/net/nx_nic directory exists before gathering data
   if [ -d /proc/net/nx_nic ]
   then
      cp -pR /proc/net/nx_nic $LOGDIR/proc/net
   fi
   # Make sure /proc/net/bonding directory exists before gathering data
   if [ -d /proc/net/bonding ]
   then
      cp -pR /proc/net/bonding $LOGDIR/proc/net
   fi
   # Make sure /proc/net/vlan directory exists before gathering data
   if [ -d /proc/net/vlan ]
   then
      cp -pR /proc/net/vlan $LOGDIR/proc/net
   fi
   # Other proc/net files
   PROC_FILES="/proc/net/arp \
   /proc/net/dev \
   /proc/net/dev_mcast \
   /proc/net/route \
   /proc/net/rt_cache"
   for file in $PROC_FILES
   do
      if [ -f $file ]
      then
         cp -p $file $LOGDIR/$file
      fi
   done
fi

echo "... done"

#####################################################################
# Gather module info
#####################################################################
echo -n "Gathering module information "
KERN_VER=`uname -r`
MAJ_VER=`echo $KERN_VER | head -c3`
if [ $MAJ_VER = "2.4" ]
then
   EXT=".o"
fi
if [ $MAJ_VER = "2.6" ]
then
   EXT=".ko"
fi

find /lib/modules/$KERN_VER/ -name qla\*$EXT -print \
  -exec modinfo {} \; -exec echo \; > $LOGDIR/modules/modinfo.out 2>&1
find /lib/modules/$KERN_VER/ -name qisioctl\*$EXT -print \
  -exec modinfo {} \; -exec echo \; >> $LOGDIR/modules/modinfo.out 2>&1
find /lib/modules/$KERN_VER/ -name qioctlmod\*$EXT -print \
  -exec modinfo {} \; -exec echo \; >> $LOGDIR/modules/modinfo.out 2>&1
find /lib/modules/$KERN_VER/ -name netxen\*$EXT -print \
  -exec modinfo {} \; -exec echo \; >> $LOGDIR/modules/modinfo.out 2>&1
find /lib/modules/$KERN_VER/ -name nx_\*$EXT -print \
  -exec modinfo {} \; -exec echo \; >> $LOGDIR/modules/modinfo.out 2>&1
find /lib/modules/$KERN_VER/ -name qlge\*$EXT -print \
  -exec modinfo {} \; -exec echo \; >> $LOGDIR/modules/modinfo.out 2>&1
find /lib/modules/$KERN_VER/ -name qlcnic\*$EXT -print \
  -exec modinfo {} \; -exec echo \; >> $LOGDIR/modules/modinfo.out 2>&1


find /lib/modules/$KERN_VER/ -name bnx\*$EXT -print \
  -exec modinfo {} \; -exec echo \; > $LOGDIR/modules/nxt2_modinfo.out 2>&1
find /lib/modules/$KERN_VER/ -name cnic\*$EXT -print \
  -exec modinfo {} \; -exec echo \; >> $LOGDIR/modules/nxt2_modinfo.out 2>&1



# Gather qisioctl and qioctlmod info (if installed)
modinfo qisioctl  >> $LOGDIR/modules/qisioctl.out  2>> $LOGDIR/script/misc_err.log
modinfo qioctlmod >> $LOGDIR/modules/qioctlmod.out 2>> $LOGDIR/script/misc_err.log

ls -alRF /lib/modules/ > $LOGDIR/modules/ls_libmodules.out



echo "... done"

#####################################################################
# Gather network info
#####################################################################
echo -n "Gathering network info "
mkdir $LOGDIR/network
mkdir $LOGDIR/network/interfaces
iptables --list > $LOGDIR/network/iptables.out 2>&1
ifconfig -a     > $LOGDIR/network/ifconfig.out 2>&1
ip addr show    > $LOGDIR/network/ipaddrshow.out 2>&1
ip -s link show > $LOGDIR/network/iplinkshow.out 2>&1
ss -a           > $LOGDIR/network/ss-s.out 2>&1
netstat -rn     > $LOGDIR/network/netstat.out
ip route        > $LOGDIR/network/ip-route.out 2>&1

which ethtool > /dev/null 2>&1
if [ $? -eq 0 ]
then
   ALLfaces=`ifconfig -a | grep HW | cut -d" " -f1`
   for file in $ALLfaces
   do
      if [ $? -eq 0 ]
      then
         ethtool -S $file > $LOGDIR/network/interfaces/ethtool-S.$file 2>&1
         ethtool    $file > $LOGDIR/network/interfaces/ethtool.$file 2>&1
         ethtool -k $file > $LOGDIR/network/interfaces/ethtool-k.$file 2>&1
         ethtool -i $file > $LOGDIR/network/interfaces/ethtool-i.$file 2>&1
         ethtool -a $file > $LOGDIR/network/interfaces/ethtool-a.$file 2>&1
         ifconfig   $file > $LOGDIR/network/interfaces/ifconfig.$file 2>&1
      fi
   done
fi

echo "... done"

#####################################################################
# Gather System Log info
#####################################################################
echo -n "Gathering syslog info "
mkdir $LOGDIR/logs
if [[ $UBUNTU -eq 1 ]]
then
LOG_FILES="/var/log/syslog* \
/var/log/warn* \
/var/log/dmesg* \
/var/log/boot*"
else
LOG_FILES="/var/log/messages* \
/var/log/warn* \
/var/log/dmesg* \
/var/log/boot*"
fi


for file in $LOG_FILES
do
   if [ -f $file ]
   then
      cp -p $file $LOGDIR/logs 2>> $LOGDIR/script/misc_err.log
   fi
done

dmesg > $LOGDIR/logs/dmesg.out
ls -alRF /var/crash > $LOGDIR/OS/ls_varcrash.out 2>> $LOGDIR/script/misc_err.log
echo "... done"

#####################################################################
# Gather boot info
#####################################################################
echo -n "Gathering boot info "
mkdir $LOGDIR/boot
BOOT_FILES="/boot/grub/grub.conf \
/boot/grub/menu.lst \
/boot/efi/efi/SuSE/elilo.conf \
/boot/efi/efi/redhat/elilo.conf \
/etc/lilo.conf \
/etc/elilo.conf"

for file in $BOOT_FILES
do
   if [ -f $file ]
   then
      cp -p $file $LOGDIR/boot
   fi
done

if [ -f /etc/grub.conf ]
then
   cp -p /etc/grub.conf $LOGDIR/boot/etc_grub.conf
fi

ls -alRF /boot > $LOGDIR/boot/ls_boot.out
echo "... done"




####################################################################
# Gather iSCSI info  
####################################################################

if [ $ISCSIINSTALLED = 1 ]
then
   if [ -d /var/lib/iscsi/ifaces ]
   then
      mkdir $LOGDIR/iSCSI
      mkdir $LOGDIR/iSCSI/var-lib-iscsi-ifaces
      cp /var/lib/iscsi/ifaces/* $LOGDIR/iSCSI/var-lib-iscsi-ifaces
   fi
fi


####################################################################
# Gather FabricCache info  
####################################################################


if [ $FCAINSTALLED = 1 ]
then
  echo -n "running hcli commands ... "

  hcli version > $LOGDIR/fca/hcli_installed.txt
  echo -n "installed ... "
  echo  "Gathering QLE10000 HBA configuration information ... "
#
# loop to deal with multiple QLE10000 HBAs 
#
  grep Fibre $LOGDIR/misc/lspci-v.out | grep f001 > $LOGDIR/fcas
  i=0
  while [[ $i -lt $( cat $LOGDIR/fcas | wc -l ) ]]
  do
    mkdir $LOGDIR/fca/fca$i
    hcli show system_capture /fca=$i > $LOGDIR/fca/fca$i/show-sys-capture.out
    hcli show cluster >> $LOGDIR/fca/fca$i/show-sys-capture.out
    hcli show cluster > $LOGDIR/fca/fca$i/show-cluster.out
    UBOOT=`grep -i u-boot $LOGDIR/fca/fca$i/show-cluster.out`
    HWVERS=`fgrep "HW Version" $LOGDIR/fca/fca$i/show-cluster.out`
    hcli list log /fca=$i > $LOGDIR/fca/fca$i/list-log.out 
    hcli save capture_file /file=/tmp/hcli-save_capture-fca$i /fca=$i 2>&1
    hcli save log /file=/tmp/save_log-fca$i.bin /fca=$i 2>&1
    hcli show adapter /fca=$i > $LOGDIR/fca/fca$i/show-adapter.out
    hcli show cluster /fca=$i > $LOGDIR/fca/fca$i/show-cluster.out
    hcli show device /fca=$i > $LOGDIR/fca/fca$i/show-device.out
    hcli show drive /fca=$i > $LOGDIR/fca/fca$i/show-drive.out
    hcli show fc /fca=$i > $LOGDIR/fca/fca$i/show-fc.out
    hcli show lun /fca=$i > $LOGDIR/fca/fca$i/show-lun.out
    hcli show lun_statistics /fca=$i > $LOGDIR/fca/fca$i/show-lun_statistics.out
    hcli show memory /fca=$i > $LOGDIR/fca/fca$i/show-memory.out
    hcli show pool /fca=$i > $LOGDIR/fca/fca$i/show-pool.out
    hcli show statistics /fca=$i > $LOGDIR/fca/fca$i/show-statistics.out
    hcli show target /fca=$i > $LOGDIR/fca/fca$i/show-target.out
    mv /tmp/hcli-save_capture-fca$i* $LOGDIR/fca/fca$i
    mv /tmp/save_log-fca$i* $LOGDIR/fca/fca$i
    (( i++ ))
  done
  rm $LOGDIR/fcas
  echo "done"
fi


####################################################################
# BR series info  
####################################################################
BRHOME=/opt/brocade/adapter
BFASS=0

if [ -f /usr/bin/bfa_supportsave -a $BRINSTALLED -eq 1 ]
then
   if [ -f /usr/bin/bfa_supportsave ]
   then
     BFASS=1
     echo -n  "Gathering BR series support information (lengthy pause here) "
     mkdir $LOGDIR/BR/bfaSS
     bfa_supportsave $LOGDIR/BR/bfaSS > /dev/null 2>&1
     CWD=`pwd`
     cd $LOGDIR/BR/bfaSS
     FIL=`tar -tzf bfa_supportsave*gz | grep bfa_ss.txt`
     tar -xzf bfa_supportsave*gz $FIL
     mv ./bfa_ss_out*/bfa_ss.txt $LOGDIR/BR/bfaSS
     rmdir bfa_ss_out*
     cd $CWD
  fi
  echo ... done
  if [ -f $BRHOME ]
  then
     mkdir $LOGDIR/BR/opt
     echo "BR series installed files" > $LOGDIR/BR/opt/brocade_installed
     ls -laR $BRHOME >> $LOGDIR/BR/opt/brocade_installed
     #-------- BR installer --------
     echo -n "Gathering BR installer support save "
     mkdir $LOGDIR/BR/installerSS
     cp $BRHOME/UninstallBrocade\ Adapter\ Software/installvariables.properties $LOGDIR/BR/installerSS
     cp /var/log/brocade/*.log $LOGDIR/BR/installerSS
     echo "... done"
     echo ""
  fi
  #-------- BR hcm --------
  if [ -d /root/HCM/data ];
  then
     echo -n "Gathering HCM support save "
     mkdir $LOGDIR/BR/hcmSS
     cp -r /root/HCM/data $LOGDIR/BR/hcmSS
     echo "... done"
  fi
  #-------- BR agent --------
  mkdir $LOGDIR/BR/agentSS
  if [ -d $BRHOME/hbaagent ];
  then
     echo -n "Gathering BR hba agent support save "
     cp -r $BRHOME/hbaagent/log $LOGDIR/BR/agentSS
     cp -r $BRHOME/hbaagent/conf $LOGDIR/BR/agentSS
     echo ... done
  else
     echo "Unable to find BR agent directories" > $LOGDIR/BR/agentSS/BRagent.txt
  fi
fi


##############################
# Q Management tools section #
##############################

mkdir $LOGDIR/QLogic_tools

####################
# Gather scli info #
####################

#if [ $FCINSTALLED -eq 1 ]
#then
   echo  "Searching for QLogic FC CLI ... "

   SCLIHOME=na
   SCLIset=0


if [ -x $QHOME/QConvergeConsoleCLI/qaucli ]
then
   SCLIHOME=$QHOME/QConvergeConsoleCLI
   SCLIset=1
elif [ -x $QHOME/QCS/QCScli ]
then
   SCLIHOME=$QHOME/QCS
   SCLIset=2
elif [ -x $QHOME/SANsurferCLI/scli ]
then
   SCLIHOME=$QHOME/SANsurferCLI
   SCLIset=3
fi
echo "... done"

if [ $SCLIHOME <> na ]
then
   echo -n "Gathering adapter configuration information "
   echo "" >> $LOGDIR/QLogic_tools/scli_installed.txt
   echo $SCLIHOME >> $LOGDIR/QLogic_tools/scli_installed.txt
   if [ $SCLIset -eq 1 ]
   then
      $SCLIHOME/qaucli -v 2>> $LOGDIR/script/misc_err.log >> $LOGDIR/QLogic_tools/scli_installed.txt
      echo "" >> $LOGDIR/QLogic_tools/scli_installed.txt
      $SCLIHOME/scli -v 2>> $LOGDIR/script/misc_err.log >> $LOGDIR/QLogic_tools/scli_installed.txt
      echo "========================" >>  $LOGDIR/QLogic_tools/scli_installed.txt
      $SCLIHOME/scli -z > $LOGDIR/QLogic_tools/scli.out 2>&1
   elif [ $SCLIset -eq 2 ]
   then
      $SCLIHOME/QCScli -t PhyAdapters "info all" > $LOGDIR/QLogic_tools/scli.out 2>&1
   fi
fi
echo "... done"


#oldcode - don't lose
#   if [ -x $QHOME/QConvergeConsoleCLI/scli ]
#   then
#      SCLIHOME=$QHOME/QConvergeConsoleCLI
#   elif [ -x $QHOME/SANsurferCLI/scli ]
#   then
#      SCLIHOME=$QHOME/SANsurferCLI
#   fi
#
#   if [ $SCLIHOME <> na ]
#   then
#      echo -n "Gathering FC configuration information "
#      echo "" >> $LOGDIR/QLogic_tools/scli_installed.txt
#      $SCLIHOME/qaucli -v 2>> $LOGDIR/script/misc_err.log >> $LOGDIR/QLogic_tools/scli_installed.txt
#      echo "" >> $LOGDIR/QLogic_tools/scli_installed.txt
#      $SCLIHOME/scli -v 2>> $LOGDIR/script/misc_err.log >> $LOGDIR/QLogic_tools/scli_installed.txt
#      echo "========================" >>  $LOGDIR/QLogic_tools/scli_installed.txt
#      $SCLIHOME/scli -z > $LOGDIR/QLogic_tools/scli.out 2>&1
#   fi
#
#   echo "... done"
#fi





#####################
# Gather iscli info #
#####################

if [ $ISCSIINSTALLED -eq 1 ]
then
   echo -n "Searching for QLogic iSCSI CLI "

   ISCLIHOME=na

   if [ -x $QHOME/QConvergeConsoleCLI/iscli ]
   then
      ISCLIHOME=$QHOME/QConvergeConsoleCLI
   elif [ -x $QHOME/SANsurferCLI/iscli ]
   then
      ISCLIHOME=$QHOME/SANsurferCLI
   fi
     
   if [ $ISCLIHOME <> na ]
   then
      echo -n "Gathering iSCSI configuration information "
      echo "" >> $LOGDIR/QLogic_tools/iscli_installed.txt
      $ISCLIHOME/iscli -ver 2>> $LOGDIR/script/misc_err.log >> $LOGDIR/QLogic_tools/iscli_installed.txt
      echo "========================" >>  $LOGDIR/QLogic_tools/iscli_installed.txt
      echo  "Gathering FC configuration information ... "
      $ISCLIHOME/iscli -c > $LOGDIR/QLogic_tools/iscli.out 2>&1
      $ISCLIHOME/iscli -ch >> $LOGDIR/QLogic_tools/iscli.out 2>&1
      echo "... done"
   fi
   echo "... done"
fi      

###################
# Gather GUI info #
###################


if [ -d $QHOME ]
then
   ls -alRF $QHOME > $LOGDIR/QLogic_tools/ls_optQLogic.out

   if [ -d $QHOME/FW_Dumps ]
   then
      mkdir $LOGDIR/QLogic_tools/firmwaredumps
      cp $QHOME/FW_Dumps/* $LOGDIR/QLogic_tools/firmwaredumps 2>> $LOGDIR/script/misc_err.log
   fi

   GUIHOME=na
   
   if [ -x $QHOME/QConvergeConsole/tomcatqcc ]
   then 
      GUIHOME=$QHOME/QConvergeConsole
      if [ -f $GUIHOME/apache-tomcat-*/bin/version.sh ]
      then
         $GUIHOME/apache-tomcat-*/bin/version.sh > $LOGDIR/QLogic_tools/gui_installed.txt
      fi
   elif [ -x $QHOME/SANsurfer/qlogic.jar ]
   then
      GUIHOME=$QHOME/SANsurfer
#      SS_CLASS="com/qlogic/qms/hba/Res.class"
#      SSVER=`unzip -p $SS_LOC $SS_CLASS | strings | grep Build`
#      echo "SANsurfer FC Manager         Version $SSVER" > $LOGDIR/QLogic_tools/sansurfer_fc_installed.txt
      if [ -x /usr/local/bin/qlremote ]
      then
         QLREMOTE=`/usr/local/bin/qlremote -v|grep -m1 Version`
         echo "SANsurfer FC Remote Agent    $QLREMOTE" >>$LOGDIR/QLogic_tools/sansurfer_fc_installed.txt
      else
         echo "SANsurfer FC Remote Agent not found or not installed" >>$LOGDIR/QLogic_tools/sansurfer_fc_installed.txt
      fi
      if [ -f $ISS_LOC -a ISCSIINSTALLED -eq 1 ]
      then
         ISS_LOC="/opt/QLogic_Corporation/SANsurfer/skins/power/iscsi_skin.properties"
         ISSNAME=`grep iscsi.main.application.name $ISS_LOC |cut -d " " -f3-6`
         ISSVER=`grep iscsi.main.application.version $ISS_LOC |cut -d " " -f3`
         echo "$ISSNAME      Version $ISSVER" > $LOGDIR/QLogic_tools/sansurfer_iscsi_installed.txt
         if [ -x /usr/local/bin/iqlremote ]
         then
            IQLREMOTE=`/usr/local/bin/iqlremote -v|grep -m1 Version`
            echo "SANsurfer iSCSI Remote Agent $IQLREMOTE" >>$LOGDIR/QLogic_tools/sansurfer_iscsi_installed.txt
         else
            echo "SANsurfer iSCSI Remote Agent not found or not installed" >>$LOGDIR/QLogic_tools/sansurfer_iscsi_installed.txt
         fi
      else
         echo "SANsurfer iSCSI Manager not found or not installed" > $LOGDIR/QLogic_tools/sansurfer_iscsi_installed.txt
      fi
   else
      echo "SANsurfer FC Manager not found or not installed" > $LOGDIR/QLogic_tools/sansurfer_fc_installed.txt
   fi
fi


#####################
# Check api version #
#####################

touch $LOGDIR/QLogic_tools/api_installed.txt
APIFILES="/usr/lib/libqlsdm.so /usr/lib64/libqlsdm.so"
for file in $APIFILES
do
   if [ -f $file ]
   then
      APIVER=`strings $file | grep "library version"`
   else
      APIVER="Not Installed"
   fi
   echo "API $file:   $APIVER" >> $LOGDIR/QLogic_tools/api_installed.txt
done

ls -alRF /usr/local/bin > $LOGDIR/QLogic_tools/ls_usrlocalbin.out

if [ -d /usr/src ]
then
   ls -alRF /usr/src/ > $LOGDIR/QLogic_tools/ls_usrsrc.out
fi

if [ -d /usr/src/qlogic ]
then
   cd /usr/src/qlogic
   tar cf $LOGDIR/QLogic_tools/driver_logs.tar `find . -name \*.log -print`
   cd $LOGDIR
fi
#   echo "... done"


#####################################################################
# BR Management Tools Section
#####################################################################

if [ $BRINSTALLED -eq 1 ]
then
   if [[ -f /usr/bin/bcu ]]
   then
      /usr/bin/bcu -v > $LOGDIR/BR/bcu-version
   fi
fi


#--------------------------------

echo ""
echo "Formatting Output"
echo ""

#--------------------------------

#####################################################################
# Start of dashboard.sh
#####################################################################
# Post-process script output into pdeudo-meaningful html
#####################################################################
echo -n "Creating dashboard.html "
cd $LOGDIR

# Create revisionhistory.txt for the script output
cat > $LOGDIR/script/revisionhistory.txt <<!
QLogic Linux Information Gathering Script - Revision History

 Revision History
  Rev  4.14.02 2016/10/13
        - verified E3 in CentOS 7.2, fix for 'missing' Ubuntu data in E4 test
  Rev  4.14.01 2016/09/8
        - resolve issue testing for fstlnq
  Rev  4.14.00 2016/09/8
        - start of support for E4
  Rev  4.13.02 2016/05/16
        - Capture iscsi offload config files
  Rev  4.13.01 2015/04/23
        - modifying how we capture data for system ram (to accommodate more platforms)
  Rev  4.13.00 2015/04/23
        - start of support for Ubuntu
  Rev  4.12.03 2015/04/3
        - cleaning up screen formatting
  Rev  4.12.02 2015/01/28
        - added / modified nxt2 hw rev
  Rev  4.12.01 2014/08/27
        - adding support for bcu on the dashboard
  Rev  4.12.00 2014/08/27
        - coding around on motherboard NX2 ASICs with inbox drivers
  Rev  4.11.17 2014/08/27
        - added:  multipathd, multipath, dmidecode, nxt2 drivers to OS section
  Rev  4.11.16 2014/08/27
        - Resolve links within copied system directories.
  Rev  4.11.15 2014/08/26
        - Several changes, largely in the startup & constants section. 
  Rev  4.11.14 2014/08/22
        - Putting in a switch (L) to force gathering of system dirs/files
  Rev  4.11.13 2014/08/10
        - Adding routines to copy system directory structures
  Rev  4.11.12 2014/07/30
        - Adding calls from nxt2 python script 
  Rev  4.11.11 2014/07/24
        - Adding brocade hcm, install, & agent log data 
  Rev  4.11.10 2014/07/24
        - Adding detection for qcc
  Rev  4.11.09 2014/07/09
        - Cleaning up management tools section
  Rev  4.11.08 2014/06/24
        - Adding code to capture NetXtreme HW revision
  Rev  4.11.07 2014/06/24
        - Cleaning up management tools section
  Rev  4.11.06 2014/06/23
        - Changing/simplifying dashboard header section
  Rev  4.11.05 2014/06/19
        - Removing references to Broadcom (where possible)
  Rev  4.11.04 2014/06/18
        - More dashboard cleanup. QLogic Drivers Loaded, QLogic Adapters Installed, fix Q-message logs
  Rev  4.11.03 2014/06/12
        - Working on logic to detect difference between running and installed fc driver
  Rev  4.11.02 2014/06/11
        - continuing dashboard cleanup
  Rev  4.11.01 2014/06/10
        - Dashboard cleanup
        - Adding NetXtreme driver info
  Rev  4.11.00 2014/06/09
        - Adding support for NetXtreme adapters
  Rev  4.10.02 2014/04/15
        - 'repair' driver parameter listing (dashboardm)
  Rev  4.10.01 2014/04/14
        - Source BR model info from bfa_ss.txt 
  Rev  4.10.00 2014/04/14
        - Continuing NetXtreme support. Adding output from bfa_ss.txt to dashboard
  Rev  4.08.01 2014/04/08
        - Adding support for NetXtreme adapters
  Rev  4.08.00 2014/03/14
        - Fixed code to get save capture on multiple QLE10Ks in same server
  Rev  4.07.08 2014/03/14
        - got rid of path in hcli calls
  Rev  4.07.07 2013/06/18
        - cleaning up a section of the QLE10000 HBA code
  Rev  4.07.06 2013/03/19
	- added SSD serial number to QLE10000 info section of dashboard
  Rev  4.07.05 2013/03/19
        - fixed some formatting on the dashboard
  Rev  4.07.04 2013/03/15
        - further modified QLE10000 information to include hcli pool & fc info
  Rev  4.07.03 2013/02/27
	- Modified FC/QLE10000 information to all go into the same section.
  Rev  4.07.02 2013/02/27
        - Added hcli output section to details page
  Rev  4.07.01 2013/02/26
        - Added test to check for fc/fca conflict
  Rev  4.07.00 2013/02/22
        - Added support for mult fca(s)
  Rev  4.06.01 2013/01/15
        - Adding additional hcli calls
  Rev  4.06.00 2013/01/15
	- Start of support for QLE10000
  Rev  4.05.00 2012/12/11
	- Removed Infiniband support
  Rev  4.04.10 2012/04/25
      - Minor mod for dashboard to scan correct file for FC Link state
  Rev  4.04.09 2012/02/07
      - Added netscli
  Rev  4.04.08 2011/11/29
      - Rather than trying to guess /sbin, /usr/sbin paths, just fix $PATH
      - Added "ip cmd show" to report address and link info (ifconfig deprecated)
      - Finally (so we hope) got rid of the duplicate driver params in the dashboard
  Rev  4.04.07 2011/10/05
      - Changes to include new path for fc/iscsi/nic cli tools
  Rev  4.04.06 2011/09/23
      - Added "top" output
      - Added /etc/modprobe.d/scsi_mod.conf (RHEL 6.x)
  Rev  4.04.05 2011/09/08
      - Tweaks to address Mellanox LOM 
      - Added /sbin and /usr/sbin for commands "hidden" by sudo
  Rev  4.04.04  2011/09/01
      - Changes to include /etc/modprobe.d/<module>.conf files
  Rev  4.04.03  2011/06/14
      - Added MPI queries
      - Temporarily removed "df" command due to some problems on RHEL 6
      - Started other changes for RHEL 6 issues
      - Added anaconda to sosreport and ~/anaconda-ks.cfg (RHEL) ~/autoinstall.xml (SLES) files
  Rev  4.04.02  2011/05/04
      - Added Rocks version to dashboard
      - Only gather IB fabric information if adapter state is active
      - "pulled" ibdiagnet because it has shown problems on some fabrics
  Rev  4.04.01  2011/04/13
      - Barely out of the box and have to make a change ...
      - Added /etc/tmi.conf
  Rev  4.04.00  2011/04/12
      - Major changes to include Infiniband host and fabric information
      - Restructure of qla_linux_info.sh to query QLogic hardware before querying
        product-related info
      - New script is qla_linux_ibinfo.sh
  Rev  4.02.08  2011/03/04
      - Added /opt/QLogic_Corporation/FW_Dumps/*
      - Added sosreport (RHEL) and supportconfig (SLES)
      - Added FC driver version check to detect RAMDISK mismatch
  Rev  4.02.07a 2010/05/17
      - Added some minor changes to capture more IB goodies
  Rev  4.02.07  2010/04/22
      - Added /etc/sysctl.conf for collection
  Rev  4.02.06  2010/04/02
      - Removed VMware info to new qla_vmware_info.sh script
      - Added a few Infiniband goodies in lieu of a major overhaul of the IB script
      - Minor tweaks to remove some more errors introduced with the new changes
  Rev  4.02.05  2010/03/05
      - Added ls /var/crash
      - Added a few more VMware goodies until qla_vmware_info.sh is complete
  Rev  4.02.04  2010/02/19
      - Minor fixes to remove error messages
      - Moved OS stuff to the front to check for VMware
      - Plans (commented for now) to check for VMware and exit when separate VMWare script done
      - Added esx and vmk commands if VMware 
  Rev  4.02.03  2010/01/19
      - Added vmware logs
  Rev  4.02.02  2009/11/24
      - Added ethtool -k to get offload info on QLogic NICs and CNAs.
      - Changed where we look to get scli information (go directly to /opt)
  Rev  4.02.01  2009/11/13
      - Minor fix to the "which xxx" commands.  Some OSes did not like the redirect.
      - Add /proc/net/bonding and /proc/net/vlan for FCoE and Netxen.
      - Modified sysfs gathering due to changes with SLES 11.
      - Finally got rid of index.html.
      - Added modinfo for qioctlmod module
  Rev  4.02.00  2009/09/02
      - Significant modifications to restructure dashboard and gather additional data
      - Added more FC info from /sys for inbox driver
      - Added separate modinfo query for qisioctl to more easily add to dashboard
      - Integrated SANsurfer / agent / [i]scli / API version info into mgmt tools section
      - Added section for ethernet info (FCoE and NetXen NICs)
      - Moved dashboard.html and details.html to root directory of tgz file and deprecated index.html
  Rev  4.01.01  2009/07/14
      - Fixed serious bug -NOT- changed title from Windows to Linux (can't be having that!)
      - Changed reference from "Readme" to "Details" (readme.html is now details.html)
  Rev  4.01.00  2009/05/14
      - Significant modifications to gather additional data (and clear the RFE stack)
      - Added logger entry for script start (pointless to do one at the end of the script)
      - Added more files collected from /proc directory
      - Added modinfo for qisioctl module
      - Added temporary tgz fix for /sys files causing extraction errors
      - Added version query for /usr/lib[64]/libqlsdm.so (API)
      - Added more command queries (lsscsi lsof free vmstat sysctl)
  Rev  4.00.06  2009/03/12
      - Added check for script run with root permissions
      - Added /etc/*-release /etc/*_version to verify supported distributions
  Rev  4.00.05  2009/01/27
      - Added dmidecode output
      - Changed datecode on the tgz filename from MMDDYY to YYMMDD
  Rev  4.00.04  2008/11/10
      - Added driver & scsi parameters to dashboard
  Rev  4.00.03  2008/10/27
      - Added GCC version to dashboard
  Rev  4.00.02  2008/08/13
      - Fix directory listing of 32-bit and 64-bit loadable libraries
  Rev  4.00.01  2008/08/06
      - Add directory listing of 32-bit and 64-bit loadable libraries
  Rev  4.00.00  2007/12/07
      - Major restructuring to add html dashboard
      - added /proc/cpuinfo
  Rev  3.00.01  2007/08/23
      - Add driver_logs.tar to capture driver installation logs
      - Change iscli to use the new "-z" option
  Rev  3.00.00  2007/01/18
      - Change output directory and tgz name to assure uniqueness
      - Add iscli_info.sh script to this script
  Rev  2.00.03  2006/12/18
      - Add uptime
  Rev  2.00.02  2006/04/19
      - Add gcc info
  Rev  2.00.01  2006/03/23
      - Add ls -alRF /sys
  Rev  2.00.00  2006/03/16
      - Major restructuring to remove OS-specific errors
  Rev  1.00.04  2006/12/06
      - Add ifconfig info
      - Add ls -alR /etc/rc.d/ /opt/QLogic* /usr/local/bin
      - Add chkconfig to list configured daemons
  Rev  1.00.03  2005/05/20
      - Add SuSE ia64 goodies
      - Add /etc/qla2xxx.conf
  Rev  1.00.02  2005/03/28
      - Add lspci -v (hwconf info)
      - Add scli -z all (if installed)
      - Add qla4xxx for QLA4010 on 2.6 kernel
      - Add dmesg command when no /var/log/dmesg file
  Rev  1.00.01  2005/03/28
      - Start of Revision History
!

#####################################################################
# Create dashboard.html for the script output
#####################################################################
DBH=$LOGDIR/dashboard.html
#
# Header
#
cat > $DBH <<!
<head><title>QLogic Linux Information Gathering Script - Dashboard</title></head> 
<body> 
<font face="Courier New"> 
 <a id="top"></a> 
<div align="center"> 
<b>QLogic Linux Information Gathering Script Dashboard</b><br> 
!
echo `date` >> $DBH
echo "<hr><hr></div>" >> $DBH

#
# Header
#
cat >> $DBH <<!
<pre>Script Version $ScriptVER
<b>Index:</b><hr> 
Dashboard Links:
!

echo  "<a href=\"#systeminfo\">System Information</a>" >> $DBH
echo  "<a href=\"#mgmtinfo\">QLogic Management Tools</a>" >> $DBH
echo "<a href=\"#drvrs\">Loaded Drivers</a>" >> $DBH
echo "<a href=\"#adaptrs\">Installed Adapters</a>" >> $DBH

if [ $FCINSTALLED -eq 1 ]
then
   echo "<a href=\"#fcinfo\">QLogic Fibre Channel Information</a>" >> $DBH
   echo "<a href=\"#qfclogs\">QLogic Fibre Channel Message Logs</a>" >> $DBH
fi

if [ $BRINSTALLED -eq 1 ] 
then
   echo "<a href=\"#brfclogs\">BR Series Fibre Channel Message Logs</a>" >> $DBH
fi

if [ $NXTINSTALLED -eq 1 ] 
then
   echo "<a href=\"#nxetherlogs\">NetXtreme Ethernet Message Logs</a>" >> $DBH
fi

if [ $ISCSIINSTALLED -eq 1 ]
then
   echo "<a href=\"#iscsilogs\">iSCSI Message Logs</a>" >> $DBH
fi

echo >> $DBH
echo "Key File Links:" >> $DBH
if [ $BFASS -eq 1 ]
then
   echo "<a href=\"BR/bfaSS/bfa_ss.txt\">bfa_ss.txt</a>    - BR series FC adapter log data" >> $DBH
fi
if [ $FCINSTALLED -eq 1 ]
then
   if [ -f QLogic_tools/scli.out ]
   then
      echo "<a href=\"QLogic_tools/scli.out\">scli.out</a>      - QLogic FC log data" >> $DBH
   fi
fi
echo    "<a href=\"modules/lsmod.out\">lsmod.out</a>     - list of loaded modules" >> $DBH

if [ -f etc/modprobe.conf.local ]
then
   echo "<a href=\"etc/modprobe.conf.local\">modprobe.conf</a> - list of module parameters (modprobe.conf.local)" >> $DBH
elif [ -f etc/modprobe.d/modprobe.conf ]
then
   echo "<a href=\"etc/modprobe.d/modprobe.conf\">modprobe.conf</a> - list of module parameters" >> $DBH
elif [ -f etc/modules.conf ]
then 
   echo "<a href=\"etc/modules.conf\">modules.conf</a>  - list of module parameters" >> $DBH
fi

echo  "<a href=\"details.html\">details.html</a>  - detailed information on collected files" >> $DBH

echo "<br>" >> $DBH 

#################################################################
# End of dashboard header section:
#################################################################


# System Information
cat >> $DBH <<!
<hr><a id="systeminfo"></a><b><a href="details.html#osfiles">System Information:</a></b>     <a href="#top">top</a><hr> 
!
HOSTNAME=`cut -d " " -f2 < $LOGDIR/OS/uname`
echo "Host Name:                 $HOSTNAME" >> $DBH
echo "OS Name:                   $OSNAME" >> $DBH

if [ -f $LOGDIR/OS/SuSE-release ]
then
   echo "OS Version:                $OSVER,   $OSPATCH" >> $DBH
fi


KERNELVERSION=`cut -d " " -f3 < $LOGDIR/OS/uname`
echo "Kernel Version:            $KERNELVERSION" >> $DBH
echo "GCC Version:               `grep "gcc (" $LOGDIR/misc/gcc.out`" >> $DBH
echo "System Up Time:           `cat $LOGDIR/misc/uptime.out`" >> $DBH
if [ -f $LOGDIR/misc/dmidecode.out ]
then
   PRODNAME=`sed -n '/System Information/,/Handle/p' $LOGDIR/misc/dmidecode.out |grep "Product Name" | cut -d ":" -f2`
   MFGRNAME=`sed -n '/System Information/,/Handle/p' $LOGDIR/misc/dmidecode.out |grep "Manufacturer" | cut -d ":" -f2`
   if [ -z "$PRODNAME" -o -z "$MFGRNAME" ]
   then
      PRODNAME=`sed -n '/Base Board Information/,/Handle/p' $LOGDIR/misc/dmidecode.out |grep "Product Name" | cut -d ":" -f2`
      MFGRNAME=`sed -n '/Base Board Information/,/Handle/p' $LOGDIR/misc/dmidecode.out |grep "Manufacturer" | cut -d ":" -f2`
   fi
   echo "System Manufacturer:      $MFGRNAME" >> $DBH
   echo "System Model:             $PRODNAME" >> $DBH
fi
if [ -f $LOGDIR/proc/cpuinfo ]
then
   CPUMODEL=`grep "model name" $LOGDIR/proc/cpuinfo |uniq |cut -d " " -f3-9`
   CPUCOUNT=`grep -c "model name" $LOGDIR/proc/cpuinfo`
   CPUSPEED=`grep "cpu MHz" $LOGDIR/proc/cpuinfo |uniq |cut -d " " -f3-9`
   echo "CPU Info:                  (x$CPUCOUNT) $CPUMODEL, $CPUSPEED MHz" >> $DBH
fi


if [[ -f $LOGDIR/logs/dmesg || -f $LOGDIR/logs/dmesg.out ]]
then
   if [[ $XEN -eq 1  ||  $UBUNTU -eq 1 || $SLES -eq 1 ]]
   then
      MEM=`grep Memory $LOGDIR/logs/dmesg.out | cut -d "]" -f2 | cut -d " " -f3,4`
   else
      MEM=`grep -i memory $LOGDIR/logs/dmesg | grep System | cut -d"(" -f2 | cut -d")" -f1 | cut -d" " -f3`
   fi
   echo "System RAM:                $MEM" >> $DBH
elif [ -f $LOGDIR/logs/dmesgout ]
then
   MEM=`grep -i memory $LOGDIR/logs/dmesgout | grep System | cut -d"(" -f2 | cut -d")" -f1 | cut -d" " -f3`
fi


if [ -f $LOGDIR/misc/dmidecode.out ]
then
   BIOSVEND=`sed -n '/BIOS Information/,/Handle/p' $LOGDIR/misc/dmidecode.out |grep "Vendor" | cut -d ":" -f2`
   BIOSVERS=`sed -n '/BIOS Information/,/Handle/p' $LOGDIR/misc/dmidecode.out |grep "Version" | cut -d ":" -f2`
   BIOSDATE=`sed -n '/BIOS Information/,/Handle/p' $LOGDIR/misc/dmidecode.out |grep "Release Date" | cut -d ":" -f2`
   echo "BIOS Version:             $BIOSVEND  Version $BIOSVERS  $BIOSDATE" >> $DBH
fi
echo >> $DBH

mkdir $LOGDIR/QLogic


cat >> $DBH <<!
<hr><a id="drvrs"></a><b><a href="details.html#osfiles">Drivers:</a></b>     <a href="#top">top</a><hr>
!
echo >> $DBH

if [ $QINSTALLED -eq 1 ]
then
  echo "<B>--------------------------</B>" >> $DBH
  echo "<B>QLogic Drivers Loaded:</B>" >> $DBH
  echo "<B>--------------------------</B>" >> $DBH

  if [ $FCINSTALLED -eq 1 ]
  then
    Q2XDVR=`grep -m1 qla2 $LOGDIR/modules/lsmod.out | cut -d" " -f1`
    modinfo $Q2XDVR > $LOGDIR/QLogic/modinfo-$Q2XDVR
    Q2XDVRVRSN=`grep -m1 version $LOGDIR/QLogic/modinfo-$Q2XDVR`
    echo Driver: $Q2XDVR, $Q2XDVRVRSN >> $DBH
  fi


  if [ $FASTLINQINSTALLED -eq 1 ]
  then
    FLQDVR=`grep -m1 qede $LOGDIR/modules/lsmod.out | cut -d" " -f1`
    modinfo $FLQDVR > $LOGDIR/QLogic/modinfo-$FLQDVR
    FLQDVRVRSN=`grep -m1 version $LOGDIR/QLogic/modinfo-$FLQDVR`
    echo Driver: $FLQDVR, $FLQDVRVRSN >> $DBH
    echo "" >> $DBH
  fi


  if [ $ISCSIINSTALLED -eq 1 ]
  then
     echo "<B>iSCSI Driver Parameters:</B>" >> $DBH
     if [ -f $LOGDIR/etc/modprobe.conf.local ]
     then
        grep -h "options qla4" $LOGDIR/etc/modprobe.conf.local >> $DBH
     fi
     if [ -f $LOGDIR/etc/modprobe.conf ]
     then
        grep -h "options qla4" $LOGDIR/etc/modprobe.conf >> $DBH
     fi
     if [ -f $LOGDIR/etc/modprobe.d/qla4xxx.conf ]
     then
        grep -h "options qla4" $LOGDIR/etc/modprobe.d/qla4xxx.conf >> $DBH
     fi
     if [ -f $LOGDIR/etc/modprobe.d/modprobe.conf ]
     then
        grep -h "options qla4" $LOGDIR/etc/modprobe.d/modprobe.conf >> $DBH
     fi
  fi

   if [ $ETHERINSTALLED -eq 1 ]
   then
      echo "<B>Ethernet Module Parameters:</B>" >> $DBH
      if [ -f $LOGDIR/etc/modprobe.conf.local ]
      then
         grep -h options $LOGDIR/etc/modprobe.conf.local | egrep "qla3|qlge|qlcnic|nx_nic|netxen_nic" >> $DBH
      fi
      if [ -f $LOGDIR/etc/modprobe.conf ]
      then
         grep -h options $LOGDIR/etc/modprobe.conf | egrep "qla3|qlge|qlcnic|nx_nic|netxen_nic" >> $DBH
      fi
      if [ -f $LOGDIR/etc/modprobe.d/modprobe.conf ]
      then
         grep -h options $LOGDIR/etc/modprobe.d/modprobe.conf | egrep "qla3|qlge|qlcnic|nx_nic|netxen_nic" >> $DBH
      fi
      if [ -f $LOGDIR/etc/modprobe.d/qla3xxx.conf ]
      then
         grep -h "options qla3" $LOGDIR/etc/modprobe.d/qla3xxx.conf >> $DBH
      fi
      if [ -f $LOGDIR/etc/modprobe.d/qlge.conf ]
      then
         grep -h "options qlge" $LOGDIR/etc/modprobe.d/qlge.conf >> $DBH
      fi
      if [ -f $LOGDIR/etc/modprobe.d/qlcnic.conf ]
      then
         grep -h "options qlcnic" $LOGDIR/etc/modprobe.d/qlcnic.conf >> $DBH
      fi
      if [ -f $LOGDIR/etc/modprobe.d/nx_nic.conf ]
      then
         grep -h "options nx_nic" $LOGDIR/etc/modprobe.d/nx_nic.conf >> $DBH
      fi
      if [ -f $LOGDIR/etc/modprobe.d/netxen_nic.conf ]
      then
         grep -h "options netxen_nic" $LOGDIR/etc/modprobe.d/netxen_nic.conf >> $DBH
      fi
   fi
fi

# end of 'if qinstalled' section

#---------

if [ $BRINSTALLED -eq 1 ]
then
   echo >> $DBH
   echo "<B>--------------------------</B>" >> $DBH
   echo "<B>BR Series Drivers Loaded:</B>" >> $DBH
   echo "<B>--------------------------</B>" >> $DBH
   modinfo bfa > $LOGDIR/BR/modinfo-bfa
   BRDVRVRSN=`grep -m1 version $LOGDIR/BR/modinfo-bfa`
   echo $BRDVRVRSN > $LOGDIR/BR/driver_version
   echo Driver: bfa, $BRDVRVRSN >> $DBH
   echo >> $DBH
fi


if [ $NXTINSTALLED -eq 1 ]
then
   echo "<B>--------------------------</B>" >> $DBH
   echo "<B>E3 Network Drivers Loaded:</B>" >> $DBH
   echo "<B>--------------------------</B>" >> $DBH
   BNXDVR=`grep -m1 bnx $LOGDIR/modules/lsmod.out | cut -d" " -f1`
   modinfo $BNXDVR > $LOGDIR/NetXtreme/modinfo-bnx 
   BNXDVRVRSN=`grep -m1 version $LOGDIR/NetXtreme/modinfo-bnx`
   echo Driver: $BNXDVR, $BNXDVRVRSN    >> $DBH
   echo >> $DBH
fi


#---------

#echo "<B>BR NIC driver Parameters:</B>" >> $DBH
#if [ -f $LOGDIR/etc/modprobe.d/modprobe.conf ]
#then
#   grep -h "options bna" $LOGDIR/etc/modprobe.d/modprobe.conf >> $DBH
#fi
#if [ -f $LOGDIR/etc/modprobe.conf.local ]
#then
#   grep -h "options bna" $LOGDIR/etc/modprobe.conf.local >> $DBH
#fi
#if [ -f $LOGDIR/etc/modprobe.conf ]
#then
#   grep -h "options bna" $LOGDIR/etc/modprobe.conf >> $DBH
#fi

cat >> $DBH <<!
<hr><a id="adaptrs"></a><b><a href="details.html#osfiles">Adapters:</a></b>     <a href="#top">top</a><hr>
!

if [ $QINSTALLED -eq 1 ]
then
   echo "<B>-------------------------</B>" >> $DBH
   echo "<B>QLogic Adapters Installed</B>" >> $DBH
   echo "<B>-------------------------</B>" >> $DBH

# Added var 'FCCONFLICT' to flag when both FC & QLE10000 HBAs are installed - rs
   if [ $FCAINSTALLED -eq 1 -a $FCCONFLICT -eq 0 ]
   then 
      grep QLogic $LOGDIR/misc/lspci-v.out|grep "Fibre Channel:" | grep f001 >> $DBH
   elif [ $FCAINSTALLED -eq 1 -a $FCCONFLICT -eq 1 ]
   then
      echo "<SPAN style='color:red'>WARNING: QLogic QLE10000 HBA  installed along with FC HBA. Possible conflict.</SPAN>" >> $DBH
      echo "<SPAN style='color:red'>         Insure that no lun is zoned to both adapters.</SPAN>" >> $DBH
      grep QLogic $LOGDIR/misc/lspci-v.out|grep "Fibre Channel:" | grep f001 >> $DBH
   fi

# dashboard data for QLogic FC cards from qaucli output
#-------------------------------------------------
   if [ $FCINSTALLED -eq 1 ]
   then
      if [ -f $LOGDIR/QLogic_tools/scli.out ]
      then
         grep -A52  "HBA Model" $LOGDIR/QLogic_tools/scli.out > /tmp/fcreq
         grep -m1 "HBA Description" /tmp/fcreq >> $DBH
         grep -m2 "Port   " /tmp/fcreq >> $DBH 
         grep -m1 "Serial Number" /tmp/fcreq >> $DBH 
         grep -m1 "Bios Version" /tmp/fcreq >>  $DBH
         grep -m1 "Running Firmware" /tmp/fcreq >>  $DBH
         grep -m4 "Flash" /tmp/fcreq >>  $DBH
         grep -m2 "Subsystem" /tmp/fcreq >>  $DBH
         grep -m4 "PCIe" /tmp/fcreq >>  $DBH
         echo "" >> $DBH
         rm /tmp/fcreq
      else
         echo "cli not found" >> $DBH
      fi
   fi

   if [ $ISCSIINSTALLED -eq 1 ]
   then
      grep QLogic $LOGDIR/misc/lspci-v.out|grep "Network controller:" >> $DBH
      if [ -d /var/lib/iscsi/ifaces ]
      then
         mkdir $LOGDIR/var-lib-iscsi-ifaces
         cp /var/lib/iscsi/ifaces/* $LOGDIR/var-lib-iscsi-ifaces
      fi
 fi

if [ $ETHERINSTALLED -eq 1 ]
   then
      grep QLogic $LOGDIR/misc/lspci-v.out|grep "Ethernet controller:" | grep -v FastLinQ >> $DBH
      grep NetXen $LOGDIR/misc/lspci-v.out|grep "Ethernet controller:" >> $DBH
   # QLA8042 uses Intel NIC - report only if FC installed
      if [ $FCINSTALLED -eq 1 ]
      then
         grep "Intel Corporation 82598" $LOGDIR/misc/lspci-v.out|grep "Ethernet controller:" >> $DBH
      fi
   fi
fi  


# dashboard data for E4 (FastLinQ) adapters.
#-------------------------------------------------------------------

if [ $FASTLINQINSTALLED -eq 1 ]
then
   echo -n "Model    : ">> $DBH; grep FastLinQ $LOGDIR/misc/lspci-vvvxxx.out | grep Subsystem | cut -d" " -f 2-7 >> $DBH
   grep -A 3 "Product Name: FastLinQ" $LOGDIR/misc/lspci-vvvxxx.out > /tmp/type.out
   echo -n "Serial # : ">> $DBH; grep Serial /tmp/type.out | cut -d" " -f 4 >> $DBH
   echo -n "Part #   : ">> $DBH; grep Part   /tmp/type.out | cut -d" " -f 4,5 >> $DBH
   rm /tmp/type.out
   echo " " >> $DBH
   echo -n "MFW      : ">> $DBH; grep Bootcode $LOGDIR/QLogic_tools/scli.out | cut -d" " -f 18,19 >> $DBH
   echo -n "PXE Boot : ">> $DBH; grep "PXE Boot" /$LOGDIR/QLogic_tools/scli.out | cut -d" " -f 20,21,22 >> $DBH
   echo -n "ASIC     : ">> $DBH; grep "ASIC" /$LOGDIR/QLogic_tools/scli.out | cut -d" " -f 23,24 >> $DBH
   echo " " >> $DBH
   for nic in `for i in \`ls /sys/bus/pci/drivers/qede/\`; do ls /sys/bus/pci/devices/$i/net 2> /dev/null; done`;
   do
     bdf=`ethtool -i $nic | grep bus | grep "[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]\.[0-9a-f]" -o`

     mac=`ip -o link show $nic | grep -o ..:..:..:..:..:.. | head -n 1`
     if [ -z $mac ]
     then
        mac="-"
     fi

     state=`ip -o link show $nic | grep ',UP' -o | grep 'UP' -o`
     if [ -z $state ]
     then
        state="-"
     fi

     link=`ethtool $nic | grep "Link detected" | grep "yes\|no" -o`
     if [ -z $link ]
     then
        link="-"
     fi

   done

   echo "NIC      : "$nic >> $DBH
   echo "MAC      : "$mac >> $DBH
   echo "BDF      : "$bdf >> $DBH
   echo >> $DBH
   echo "STATE    : "$state >> $DBH
   echo "LINK     : "$link >> $DBH
   echo -n "Bus      : " >> $DBH; grep "Bus Type" /$LOGDIR/QLogic_tools/scli.out | cut -d" " -f 27,28 >> $DBH
   echo -n "Slot     : " >> $DBH; grep "Slot" /$LOGDIR/QLogic_tools/scli.out | cut -d" " -f 24 >> $DBH
   echo "-------------------------------------------------------------------" >> $DBH

   echo >> $DBH
fi


if [ $BFASS -eq 1 ]
then
  echo "<B>----------------------------</B>" >> $DBH
  echo "<B>BR Series Adapters Installed</B>" >> $DBH
  echo "<B>----------------------------</B>" >> $DBH
  grep "model info" -A 5 $LOGDIR/BR/bfaSS/bfa_ss.txt | cut -f 2,3,4 >> $DBH
  grep "Flash Information" -A 7 $LOGDIR/BR/bfaSS/bfa_ss.txt >> $DBH
  if [ -f /usr/bin/bcu ]
  then
     /usr/bin/bcu port --list >> $DBH
  fi
echo >> $DBH
fi

#URHERE
if [ $NXTINSTALLED -eq 1 ]
then

   grep BCM578 $LOGDIR/misc/lspci.out > /tmp/nxt-out
   while read string
   do
      asic=`echo $string | cut -d" " -f6`
      case "$asic" in
         BCM57840)
                    DEV_NUM=`echo $string | cut -d" " -f1`
                    break
                    ;;
      esac
   done < /tmp/nxt-out
   rm /tmp/nxt-out

   DEV_ROOT="/sys/bus/pci/devices/0000:"$DEV_NUM
   VEN=`cat $DEV_ROOT/vendor`
   DEV=`cat $DEV_ROOT/device`
   SUBVEN=`cat $DEV_ROOT/subsystem_vendor`
   SUBDEV=`cat $DEV_ROOT/subsystem_device`

   grep -A30 Broadcom $LOGDIR/misc/lspci-vvvxxx.out > /tmp/bnxdat
   ADAPTER=`grep -m1 "Product Name" /tmp/bnxdat`
   PN=`grep -m1 "Part number" /tmp/bnxdat`
   SN=`grep -m1 "Serial number" /tmp/bnxdat`
   EC=`grep -m1 "Engineering changes" /tmp/bnxdat`
   MN=`grep -m1 "Manufacture ID" /tmp/bnxdat`

# check for any installed nxt2 drivers 
   DRVRS="cnic \
   bnx2x \
   bnx2i \
   bnx2fc"

   for drvr in $DRVRS 
   do
      modinfo $drvr > $LOGDIR/NetXtreme/modinf-$drvr
   done

   grep -m1 -A5 Broadcom $LOGDIR/misc/lspci-vmm.out > /tmp/revdat
   REVSRC=`grep Rev /tmp/revdat | cut -d ":" -f 2`
   REVSRC="${REVSRC#"${REVSRC%%[![:space:]]*}"}"   # removes leading spaces from REVSRC
   case "$REVSRC" in 
      00)
         HWREV="Hardware Rev: A0"
         ;;
      01)
         HWREV="Hardware Rev: A1"
         ;;
      02)
         HWREV="Hardware Rev: A2"
         ;;
      10)
         HWREV="Hardware Rev: B0"
         ;;
      11)
         HWREV="Hardware Rev: B1"
         ;;
      12)
         HWREV="Hardware Rev: B2"
         ;;
       *) 
         HWREV="Unknown HW Rev : "$REVSRC
         ;;
   esac   

   echo "<B>-----------------------------</B>" >> $DBH
   echo "<B>E3 Network Adapters Installed</B>" >> $DBH
   echo "<B>-----------------------------</B>" >> $DBH
   echo $ADAPTER >> $DBH
   echo $HWREV >> $DBH
   echo Vendor: $VEN >> $DBH
   echo Device: $DEV >> $DBH
   echo Subsystem Vendor: $SUBVEN >> $DBH
   echo Subsystem Device: $SUBDEV >> $DBH
   echo $PN >> $DBH
   echo $SN >> $DBH
   echo $EC >> $DBH 
   echo $MN >> $DBH
   echo >> $DBH
   rm /tmp/bnxdat /tmp/revdat
fi 


cat >> $DBH <<!
<hr><a id="mgmtinfo"></a><b><a href="details.html#QLogic_tools">Management Tools :</a></b>     <a href="#top">top</a><hr> 
!

if [[ $SCLIHOME != na ]]
then
   if [ $FCINSTALLED -eq 1 ]
   then
      echo "<B>QLogic FC Adapter Tools:</B>" >> $DBH
      echo >> $DBH
      echo "<B>CLI</B>" >> $DBH       
      echo "<B>-----</B>" >> $DBH
      if [ -f /opt/QLogic_Corporation/QConvergeConsoleCLI/qaucli ]
      then
         cat $LOGDIR/QLogic_tools/scli_installed.txt >> $DBH
         echo >> $DBH
      fi   
      if [[ $GUIHOME != na ]]
      then
         echo >> $DBH
         if [ $GUIHOME != na ]
         then
            echo "<B>GUI</B>" >> $DBH       
            echo "<B>-----</B>" >> $DBH
            grep \/opt $LOGDIR/QLogic_tools/gui_installed.txt | grep -v Using >> $DBH
            grep "Server version" $LOGDIR/QLogic_tools/gui_installed.txt >> $DBH
            grep "JVM Version" $LOGDIR/QLogic_tools/gui_installed.txt >> $DBH
            echo "========================" >>  $DBH
            echo >> $DBH
         fi
      fi
   fi
fi


if [ $FCAINSTALLED -eq 1 ]
then
   echo "<B>QLE10000 HBA Tools:</B>" >> $DBH
   cat $LOGDIR/fca/hcli_installed.txt >> $DBH
   echo "----------" >> $DBH
   echo >> $DBH
fi

if [ $ISCSIINSTALLED -eq 1 ]
then
   echo "<B>iSCSI Adapter Tools:</B>" >> $DBH
   cat $LOGDIR/QLogic_tools/sansurfer_iscsi_installed.txt | sed "s///" >> $DBH
   echo >> $DBH
   cat $LOGDIR/QLogic_tools/iscli_installed.txt >> $DBH
fi

if [[ $BRINSTALLED -eq 1 ]]
then
   if [ -f $LOGDIR/BR/bcu-version ]
   then
      echo "<B>BR adapter tools:</B>" >> $DBH
      cat $LOGDIR/BR/bcu-version >> $DBH
      echo >> $DBH
   fi
fi


######################################################
# Adapter information
######################################################


   if [ $FCINSTALLED -eq 1 -a $FCAINSTALLED -eq 0 ]
   then
cat >> $DBH <<!
<hr><a id="fcinfo"></a><b><a href="details.html#procinfo">QLogic Fibre Channel Adapter Information:</a></b>     <a href="#top">top</a><hr> 
!
   echo >> $DBH

   elif [ $FCINSTALLED -eq 0 -a $FCAINSTALLED -eq 1 ]
   then
cat >> $DBH <<!
<hr><a id="fcinfo"></a><b><a href="fca\fca0\show-sys-capture.out">QLE10000 HBA  Information:</a></b>     <a href="#top">top</a><hr> 
!
   echo >> $DBH

   elif [ $FCINSTALLED -eq 1 -a $FCAINSTALLED -eq 1 ] 
   then
cat >> $DBH <<!
<hr><a id="fcinfo"></a><b><a href="details.html#procinfo">Fibre Channel and QLE10000 HBA Information:</a></b>     <a href="#top">top</a><hr> 
<font color="FF0000">
WARNING: Illegal condition - A Fibre Channel HBA and a QLE10000 HBA  cannot both be in the same system
</font>
!
   echo >> $DBH
#
   elif [ $FCINSTALLED -eq 1 -o $FCAINSTALLED -eq 1 ]
   then
cat >> $DBH <<!
<hr><a id="fcinfo"></a><b><a href="details.html#procinfo">Fibre Channel or QLE10000 adapter information</a></b>     <a href="#top">top</a><hr> 
!
   echo >> $DBH
   GOTPORT=0
   DRV_MOD_VER=`/sbin/modinfo qla2xxx | grep "^version" | cut -d " " -f 9`
   TESTMOD=`grep "^qla2" $LOGDIR/modules/lsmod.out`
   if [ -n "$TESTMOD" ]
   then
      echo >> $DBH
      TESTDIR=`ls $LOGDIR/sys/class/scsi_host/ | grep host`
      if [ -n "$TESTDIR" ]
      then
         SYSDIR=`ls $LOGDIR/sys/class/scsi_host`
         for FILE in $SYSDIR
         do
            if [ -f $LOGDIR/sys/class/scsi_host/$FILE/driver_version ]
            then
               if [ -f $LOGDIR/sys/class/scsi_host/$FILE/model_name ]
               then
                  ADAPTER=`cat $LOGDIR/sys/class/scsi_host/$FILE/model_name`
                  echo "Adapter Model: $ADAPTER" >> $DBH
                  GOTPORT=1
                  if [ -f $LOGDIR/sys/class/scsi_host/$FILE/serial_num ]
                  then
                     HSERIAL=`cat $LOGDIR/sys/class/scsi_host/$FILE/serial_num`
                     echo "HBA Serial #: $HSERIAL" >> $DBH
                     if [ $FCAINSTALLED -eq 1 ]
                     then
                        DSERIAL=`hcli show drive/fca=0 | grep -m1 erial | cut -d "=" -f2 | awk '{print substr($0,5,11)}'`
                        echo "SSD Serial #: $DSERIAL" >> $DBH
                     fi
                     if [ -f $LOGDIR/sys/class/scsi_host/$FILE/driver_version ]
                     then
                        DRV_RUN_VER=`cat $LOGDIR/sys/class/scsi_host/$FILE/driver_version`
                        echo -n "Driver Version: $DRV_RUN_VER" >> $DBH
                        if [ $DRV_MOD_VER = $DRV_RUN_VER -o ${DRV_MOD_VER}-fo = $DRV_RUN_VER ]
                        then
                           echo >> $DBH
                        else
                           echo "  <SPAN style='color:red'>Running driver version does not match installed driver version ($DRV_MOD_VER).  Check RAMDISK image.</SPAN>" >> $DBH
                        fi
                        if [ -f $LOGDIR/sys/class/scsi_host/$FILE/fw_version ]
                        then
                           SOFTWARE=`cat $LOGDIR/sys/class/scsi_host/$FILE/fw_version`
                           echo "SW Version: $SOFTWARE" >> $DBH
                           LINKSTATE="$LOGDIR/sys/class/scsi_host/$FILE/link_state"       # SLES uses different file than RHEL
                           if [ -f $LINKSTATE ] 
                           then 
                              echo "Link State: `cat $LINKSTATE`" >> $DBH
                           else
                              LINKSTATE="$LOGDIR/sys/class/scsi_host/$FILE/state"
                              if [ -f $LINKSTATE ]
                              then 
                                 echo "Link State: `cat $LINKSTATE`" >> $DBH  
                                 echo "---" >> $DBH
                              fi
                           fi
                        fi
                     fi
                  fi    
               fi
#      	       echo $UBOOT >> $DBH
      	       if [ $FCAINSTALLED -eq 1 ]
               then
                  hcli show fc /fca=0 > /tmp/fcout
                  hcli show pool /fca=0 > /tmp/poo-out
                  fgrep "Port = " /tmp/fcout >> $DBH
                  fgrep "WWPN = " /tmp/fcout >> $DBH
                  fgrep "Port Status " /tmp/fcout >> $DBH
                  fgrep "Link Status " /tmp/fcout >> $DBH
                  fgrep "Current Link Rate " /tmp/fcout >> $DBH
                  fgrep "Programmed Link Rate " /tmp/fcout >> $DBH
                  fgrep "Firmware Revision " /tmp/fcout >> $DBH
                  fgrep "Frame Size " /tmp/fcout >> $DBH
                  fgrep "Execution Throttle " /tmp/fcout >> $DBH
                  fgrep "Connection Mode " /tmp/fcout >> $DBH
                  fgrep "Programmed Connection " /tmp/fcout >> $DBH	
                  echo "" >> $DBH
                  fgrep "Total SSD " /tmp/poo-out >> $DBH
                  cachestr=`grep Used /tmp/poo-out`
                  cachesize=`echo $cachestr | cut -d " " -f8`
                  if [ $cachesize -eq 0 ]
                  then
                     echo "<SPAN style='color:red'>    SSD Storage Configured for Cache Pool = 0</SPAN>" >> $DBH
                  else
                     fgrep "Configured " /tmp/poo-out >> $DBH
                  fi
                  rm /tmp/fcout
                  rm /tmp/poo-out
               fi
               if [ $FCAINSTALLED -eq 0 ]
               then
                  FLASHBIOS="$LOGDIR/sys/class/scsi_host/$FILE/optrom_bios_version"
                  if [ -f $FLASHBIOS ] 
                  then 
                     echo "Flash BIOS Version: `cat $FLASHBIOS`" >> $DBH  
                  fi
                  FLASHEFI="$LOGDIR/sys/class/scsi_host/$FILE/optrom_efi_version"
                  if [ -f $FLASHEFI ] 
                  then 
                     echo "Flash EFI Version: `cat $FLASHEFI`" >> $DBH  
                  fi
                  FLASHFCODE="$LOGDIR/sys/class/scsi_host/$FILE/optrom_fcode_version"
                  if [ -f $FLASHFCODE ] 
                  then 
                     echo "Flash Fcode Version: `cat $FLASHFCODE`" >> $DBH  
                  fi
                  FLASHFW="$LOGDIR/sys/class/scsi_host/$FILE/optrom_fw_version"
                  if [ -f $FLASHFW ] 
                  then 
                     echo "Flash Firmware Version: `cat $FLASHFW`" >> $DBH  
                  fi
                  MPIVER="$LOGDIR/sys/class/scsi_host/$FILE/mpi_version"
                  if [ -f $MPIVER ] 
                  then 
                     echo "MPI Version: `cat $MPIVER`" >> $DBH  
                  fi
                  NPIVVP="$LOGDIR/sys/class/scsi_host/$FILE/npiv_vports_inuse"
                  if [ -f $NPIVVP ] 
                  then 
                     echo "NPIV VPorts: `cat $NPIVVP`" >> $DBH  
                  fi
                  VLANID="$LOGDIR/sys/class/scsi_host/$FILE/vlan_id"
                  if [ -f $VLANID ] 
                  then 
                     echo "VLAN ID: `cat $VLANID`" >> $DBH 
                  fi
                  VNPORTMAC="$LOGDIR/sys/class/scsi_host/$FILE/vn_port_mac_address"
                  if [ -f $VNPORTMAC ] 
                  then 
                     echo "VN Port MAC Address: `cat $VNPORTMAC`" >> $DBH 
                  fi
               fi
            fi   
            if [ $GOTPORT -eq 1 ]
            then 
               GOTPORT=0
               echo >> $DBH
               echo --------------------- >> $DBH
               echo >> $DBH
            fi
         done
      fi
   fi
#   fi
fi


if [ $ISCSIINSTALLED -eq 1 ]
then
cat >> $DBH <<!
<hr><a id="iscsiinfo"></a><b><a href="details.html#procinfo">QLogic iSCSI Adapter Information:</a></b>     <a href="#top">top</a><hr> 
!
      TESTDIR=`ls $LOGDIR/proc/scsi/|grep qla4`
      if [ -n "$TESTDIR" ]
      then
         PROCDIR=`ls $LOGDIR/proc/scsi/qla4*/[0-9]*`
         for FILE in $PROCDIR
         do
            grep Adapter $FILE|grep -v flag >> $DBH
            grep Driver $FILE >> $DBH
            grep Firmware $FILE >> $DBH
            grep Serial $FILE >> $DBH
            grep target $FILE|grep scsi >> $DBH
            echo >> $DBH
         done
      else
         TESTMOD=`grep "^qla4" $LOGDIR/modules/lsmod.out`
         if [ -n "$TESTMOD" ]
         then
            echo "No /proc information available for iSCSI Driver" >> $DBH
            #Very slim pickings for qla4xxx information from /sys
            DRIVER="$LOGDIR/sys/module/qla4xxx/version"
            if [ -f $DRIVER ]
            then
               echo >> $DBH
               echo "iSCSI Driver Version: `cat $DRIVER`" >> $DBH
               echo "No additional /sys information available for iSCSI Driver" >> $DBH
               echo >> $DBH
            else
               echo "No /sys  information available for iSCSI Driver" >> $DBH
               echo >> $DBH
            fi
         else
            echo "Hardware present, but no iSCSI drivers loaded" >> $DBH
            echo >> $DBH
         fi
      fi
   fi

if [ $ETHERINSTALLED -eq 1 ]
then
cat >> $DBH <<!
<hr><a id="etherinfo"></a><b><a href="details.html#procinfo">Ethernet Adapter Information:</a></b>     <a href="#top">top</a><hr> 
!
   QLETHERDRIVER=0
   ETHDEVS=`grep "Link encap" $LOGDIR/network/ifconfig.out | cut -d " " -f1`
   for file in $ETHDEVS
   do
      if [ -f $LOGDIR/network/ethtool-i.$file ]
      then
         QLETHERDRIVER=1    
         echo "Interface:        $file" >> $DBH
         echo -n "Driver Module:    " >> $DBH
         grep driver $LOGDIR/network/ethtool-i.$file | cut -d " " -f2 >> $DBH
         echo -n "Driver Version:   " >> $DBH
         grep "^version" $LOGDIR/network/ethtool-i.$file | cut -d " " -f2 >> $DBH
         echo -n "Firmware Version: " >> $DBH
         grep firmware $LOGDIR/network/ethtool-i.$file | cut -d " " -f2 >> $DBH
         echo -n "Link Detected:    " >> $DBH
         LINKSTATE=`grep Link $LOGDIR/network/ethtool.$file | cut -d " " -f3`
         if [ -n "$LINKSTATE" ]; then echo $LINKSTATE >> $DBH ; else echo >>$DBH ; fi
         echo -n "Interface State:  " >> $DBH
         grep UP $LOGDIR/network/ifconfig.$file > /dev/null
         if [ $? -eq 0 ]; then echo UP >> $DBH
         else echo DOWN >> $DBH
         fi
         echo -n "HW Address:       " >> $DBH
         grep HWaddr $LOGDIR/network/ifconfig.$file | cut -d "W" -f2|cut -d " " -f2 >> $DBH
         echo -n "Inet Address:     " >> $DBH
         INETADDR=`grep "inet addr" $LOGDIR/network/ifconfig.$file | cut -d " " -f12-16`
         if [ -n "$INETADDR" ]; then echo $INETADDR >> $DBH ; else echo "Undefined" >> $DBH; fi
         echo -n "Inet6 Address:    " >> $DBH
         INET6ADDR=`grep "inet6 addr" $LOGDIR/network/ifconfig.$file | cut -d " " -f12-14`
         if [ -n "$INET6ADDR" ]; then echo $INET6ADDR >> $DBH ; else echo "Undefined" >> $DBH ; fi
         echo >> $DBH
      fi
   done
   echo >> $DBH
fi



################
# Message Logs #
################

if [ $FCINSTALLED -eq 1 ]
then
cat >> $DBH <<!
<hr><a id="qfclogs"></a><b><a href="details.html#loginfo">QLogic FC Message Logs:</a></b>     <a href="#top">top</a><hr> 
!
  if [[ UBUNTU -eq 1 ]]
  then
    grep qla2 /var/log/syslog* |tail -50 >> $DBH
  else
    grep qla2 /var/log/messages* |tail -50 >> $DBH
  fi
fi
echo >> $DBH


if [ $FASTLINQINSTALLED -eq 1 ]
then
cat >> $DBH <<!
<hr><a id="qfclogs"></a><b><a href="details.html#loginfo">QLogic FC Message Logs:</a></b>     <a href="#top">top</a><hr>
!
  grep qed /var/log/messages* | tail -50 >> $DBH
fi
echo >> $DBH


if [ $ISCSIINSTALLED -eq 1 ]
then
cat >> $DBH <<!
<hr><a id="iscsilogs"></a><b><a href="details.html#loginfo">QLogic iSCSI Message Logs:</a></b>     <a href="#top">top</a><hr> 
!
  if [[ UBUNTU -eq 1 ]]
  then
     grep qla4 /var/log/syslog* |tail -50 >> $DBH
  else
     grep qla4 /var/log/messages |tail -50 >> $DBH
  fi
fi
echo >> $DBH


if [ $ETHERINSTALLED -eq 1 ]
then
cat >> $DBH <<!
<hr><a id="etherlogs"></a><b><a href="details.html#loginfo">QLogic Ethernet Message Logs:</a></b>     <a href="#top">top</a><hr> 
!
   egrep "qla3|qla2xip|qlge|qlcnic" /var/log/messages |tail -50 >> $DBH
fi
echo >> $DBH

if [ $BRINSTALLED -eq 1 ]
then
cat >> $DBH <<!
<hr><a id="brfclogs"></a><b><a href="details.html#loginfo">BR Series Adapter Logs:</a></b>     <a href="#top">top</a><hr> 
!
  if [[ UBUNTU -eq 1 ]]
  then
     grep  bfa /var/log/syslog* |tail -50 >> $DBH
  else
     grep  bfa /var/log/messages* |tail -50 >> $DBH
  fi
fi
echo >> $DBH

if [ $NXTINSTALLED -eq 1 ]
then
cat >> $DBH <<!
<hr><a id="nxetherlogs"></a><b><a href="details.html#loginfo">NetXtreme Message Logs:</a></b>     <a href="#top">top</a><hr> 
!
  if [[ UBUNTU -eq 1 ]]
  then
     grep  bnx /var/log/syslog* |tail -50 >> $DBH
  else
     grep  bnx /var/log/messages* |tail -50 >> $DBH
  fi
fi
echo >> $DBH

# Wrap it up
#
# Temporary cleanup of $LOGDIR/sys to avoid extraction errors
cd $LOGDIR
if test -d ./sys
then
   tar czf $LOGDIR/OS/sys_files.tgz ./sys
   rm -rf $LOGDIR/sys
fi
# Now back to our regularly scheduled program

cat >> $DBH <<!
<hr><a id="bottom"></a> <a href="#top">top</a><hr> 
<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br> 
</pre> 
</font> 
</body>
!

echo "... done"


#####################################################################
# Start of details.sh
#####################################################################
# Post-process script output into pdeudo-meaningful html
#####################################################################
echo -n "Creating details.html "
cd $LOGDIR

# Create details.html for the script output
DTL=$LOGDIR/details.html

# Header
#
cat > $DTL <<!
<head><title>QLogic Linux Information Gathering Script - Details</title></head> 
<body> 
<font face="Courier New"> 
 <a id="top"></a> 
<div align="center"> 
<b>QLogic Linux Information Gathering Script Details</b><br> 
!
echo `date` >> $DTL
echo "<hr><hr></div>" >> $DTL


# Index
#
if [ $GETFILES -eq 1 ]
then
cat >> $DTL <<!
This is not a comprehensive listing of all files in the script output tar file. There are many files that depend on
which hardware &/or software is installed on the system under test.
<pre>
<b>Index:</b><hr>
<a href="#about">About</a>
<a href="#rainier">QLE10000 hcli output</a>
<a href="#brocde">BR Series Adapter Information</a>
<a href="#osfiles">OS Information Files</a>
<a href="#sysfiles">Some System Directories</a>
<a href="#etcfiles">/etc Information</a>
<a href="#modules">Module Information</a>
<a href="#procinfo">/proc Information</a>
<a href="#etherinfo">Network Information</a>
<a href="#QLogic_tools">QLogic Tools (SANsurfer/CLI) Information</a>
<a href="#loginfo">System Log Information</a>
<a href="#miscinfo">Miscellaneous Information</a><br>
!
else
cat >> $DTL <<!
echo "This is not a comprehensive listing of all files in the script output tar file. There are many files that depend on"
echo "what hardware &/or software is installed on the system under test."
<pre>
<b>Index:</b><hr>
<a href="#about">About</a>
<a href="#rainier">QLE10000 hcli output</a>
<a href="#brocde">BR Series Adapter Information</a>
<a href="#osfiles">OS Information Files</a>
<a href="#etcfiles">/etc Information</a>
<a href="#modules">Module Information</a>
<a href="#procinfo">/proc Information</a>
<a href="#etherinfo">Network Information</a>
<a href="#QLogic_tools">QLogic Tools (SANsurfer/CLI) Information</a>
<a href="#loginfo">System Log Information</a>
<a href="#miscinfo">Miscellaneous Information</a><br>
!
fi


#
# About
#
cat >> $DTL <<!
<hr><a id="about"></a><b><a href="details.html">About:</a></b>     <a href="#top">top</a><hr>
This details file will walk through the information gathered by the information gathering script.

<a href="dashboard.html">dashboard.html</a>
This file is the starting place for all your basic troubleshooting needs.  It displays an overview
of the server, reports Adapter driver / firmware versions, and identifies installed QLogic applications.

<a href="details.html">details.html</a>
This file.

<a href="script/revisionhistory.txt">revisionhistory.txt</a>
This file contains the revision history for the Linux Information Gathering script.

!


# BR stuff
#
cat >> $DTL <<!
<hr><a id="brocde"></a><b><a href="details.html">BR series support save</a></b>     <a href="#top">top</a><hr>
!
if [[ $BRINSTALLED -eq 1 ]]
then
  if [[ $BFASS -eq 1 ]]
  then
     echo "The output from support save on the server (bfa_supportsave) is in the directory BR" >> $DTL
     echo >> $DTL
  fi 
else
  echo "No BR series adapter found in system" >> $DTL
fi


# QLE10000
#
# formats links to all the small hcli output files gathered at runtime (commented while we continue
# to evaluate the utility of the "show system_capture" output currently linked to fca details.
#
#

cat >> $DTL <<!
<hr><a id="rainier"></a><b><a href="details.html">QLE10000 hcli output</a></b>     <a href="#top">top</a><hr>
!
echo "" >> $DTL
if [ $FCAINSTALLED -eq 1 ]
then
   RAINIER_FILES=`ls fca/fca0/list-log.out fca/fca0/show-adapter.out fca/fca0/show-cluster.out fca/fca0/show-device.out 2>> $LOGDIR/script/misc_err.log`
   for FILE in $RAINIER_FILES
   do
      echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
   done
   echo  "" >> $DTL
   echo >> $DTL
   RAINIER_FILES=`ls fca/fca0/show-drive.out fca/fca0/show-fc.out fca/fca0/show-lun.out fca/fca0/show-lun_statistics.out 2>> $LOGDIR/script/misc_err.log`
   for FILE in $RAINIER_FILES
   do
      echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
   done
   echo "" >> $DTL
   echo >> $DTL
   RAINIER_FILES=`ls fca/fca0/show-memory.out fca/fca0/show-pool.out fca/fca0/show-statistics.out fca/fca0/show-target.out 2>> $LOGDIR/script/misc_err.log`
   for FILE in $RAINIER_FILES
   do
      echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
   done
   echo "" >> $DTL
   echo "" >> $DTL
   echo "The binary files 'hcli-save_capture-fca.tar.gz & save_log-fcaX.bin are in the directory fca/fcaX" >> $DTL 
   echo "                                                                                           (X=0..3)" >> $DTL
   echo >> $DTL
else
   echo "No QLE10000 found in system" >> $DTL
fi


#
# OS Information Files
#
cat >> $DTL <<!
<hr><a id="osfiles"></a><b><a href="details.html">OS Information Files:</a></b>     <a href="#top">top</a><hr>
!
OS_FILES=`ls OS/*release OS/*version OS/uname 2>> $LOGDIR/script/misc_err.log`
for FILE in $OS_FILES
do
   echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
done
echo >> $DTL
echo "The files listed above include the OS release version and the running kernel version (uname)." >> $DTL
echo >> $DTL
if [[ $UBUNTU -eq 1 ]]
then
   OS_FILES=`ls OS/dpkg*  2>> $LOGDIR/script/misc_err.log`
else
   OS_FILES=`ls OS/rpm*  2>> $LOGDIR/script/misc_err.log`
fi
for FILE in $OS_FILES
do
   echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
done
echo >> $DTL
if [[ $UBUNTU=1 ]]
then
   echo "The file(s) above include the installed packages" >> $DTL
else   
   echo "The file(s) above include the installed RPMs." >> $DTL
   echo "Columns in rpm_details = rpm package / files in the package / file sizes" >> $DTL
fi
echo >> $DTL
OS_FILES=`ls OS/ls_* OS/sys_files.tgz  2>> $LOGDIR/script/misc_err.log`
for FILE in $OS_FILES
do
   echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
done
echo >> $DTL
echo "The files above include the output of ls -alRF for /sys and /var/crash as well as a tar/zip" >> $DTL
echo "of the collected files from /sys." >> $DTL
echo >> $DTL

#
# Boot files
#
BOOTFILES=`ls boot`
for FILE in $BOOTFILES
do
   echo -n "<a href=\"boot/$FILE\">boot/$FILE</a>    " >> $DTL
done
echo >> $DTL
echo "The above files include boot configuration files and a list of files in the /boot directory." >> $DTL
echo >> $DTL

#
# System directories
#
if [ $GETFILES -eq 1 ]
then
   cat >> $DTL <<!
   <hr><a id="sysfiles"></a><b><a href="details.html">Optional clone of system directories</a></b>     <a href="#top">top</a><hr>
!
   echo "If the Linux data gathering script is run with the '-z' switch, a clone of several system directories" >> $DTL
   echo "has been created in the directory ./OS/system-dirs" >> $DTL
   echo ""
   echo "Default behaviour is to skip any files over 2MB in size, and to log any files that can't be copied" >> $DTL
   echo "Using the standard libraries into the log ./OS/system-dirs/copy_err.log" >> $DTL
   echo >> $DTL

   SYSDIRS=`ls OS/system-dirs`
   for dir in $SYSDIRS
   do
     echo -n "<a href=\"OS/system-dirs/$dir\">OS/system-dir/$dir</a>    " >> $DTL
   done
   echo >> $DTL
fi


#
# /etc Information
#
cat >> $DTL <<!
<hr><a id="etcfiles"></a><b><a href="details.html">/etc Information:</a></b>     <a href="#top">top</a><hr>
!
ETC_FILES="etc/modprobe.conf etc/modprobe.conf.local etc/modprobe.conf.dist etc/modules.conf etc/modules.conf.local etc/sysconfig/kernel"
for FILE in $ETC_FILES
do
   if [ -f $FILE ]
   then
      echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
   fi
done
echo >> $DTL
echo "The files above are used to determine the order modules are loaded, specify optional module parameters," >> $DTL
echo "and determine which modules are included in the ramdisk image during bootup (SLES uses /etc/sysconfig/kernel)." >> $DTL
echo >> $DTL

ETC_FILES="etc/qla2xxx.conf etc/qla2300.conf etc/qla2200.conf etc/hba.conf"
ATLEASTONEFILE=0
for FILE in $ETC_FILES
do
   if [ -f $FILE ]
   then
      ATLEASTONEFILE=1
      echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
   fi
done
if [ $ATLEASTONEFILE -eq 1 ]
then
   echo >> $DTL
   echo "The file qla*.conf, if present, is used to store an ascii representation of persistent binding and" >> $DTL
   echo "LUN masking as defined by SANsurfer or scli.  The file hba.conf, if present, points to the proper " >> $DTL
   echo "dynamic loadable library for the SNIA API (HBAAPI)." >> $DTL
   echo >> $DTL
fi

ETC_FILES="etc/fstab etc/mtab"
for FILE in $ETC_FILES
do
   if [ -f $FILE ]
   then
      echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
   fi
done
echo >> $DTL
echo "The files above identify static and dynamic filesystem mount information." >> $DTL
echo >> $DTL

echo -n "<a href=\"etc/ls_etcrcd.out\">etc/ls_etcrcd.out</a>    " >> $DTL
echo >> $DTL
echo "Directory listing of all startup files executed at various runlevels at boot/shutdown" >> $DTL
echo >> $DTL

if [ -f etc/sysctl.conf ]
then
   echo -n "<a href=\"etc/sysctl.conf\">etc/sysctl.conf</a>    " >> $DTL
   echo >> $DTL
   echo "Kernel tuning configuration file." >> $DTL
   echo >> $DTL
fi

if [ -f etc/sysconfig/hwconf ]
then
   echo -n "<a href=\"etc/sysconfig/hwconf\">etc/sysconfig/hwconf</a>    " >> $DTL
   echo >> $DTL
   echo "List of installed hardware including PCI bus, vendor and driver module information." >> $DTL
   echo >> $DTL
fi


#
# Module Information
#
cat >> $DTL <<!
<hr><a id="modules"></a><b><a href="details.html">Module Information:</a></b>     <a href="#top">top</a><hr>
!
MODFILES="modules/ls_libmodules.out modules/lsmod.out modules/modinfo.out modules/qisioctl.out modules/qioctlmod.out"
for FILE in $MODFILES
do
  if test -f $FILE
  then
    echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
  fi
done
echo >> $DTL
echo "The file ls_libmodules.out is a list of all modules for the current running kernel.  The file " >> $DTL
echo "lsmod.out is a list of all currently loaded modules.  The file modinfo.out is a list of modinfo" >> $DTL
echo "output of all QLogic modules in the current running kernel." >> $DTL
echo >> $DTL

#
# /proc Information
#
cat >> $DTL <<!
<hr><a id="procinfo"></a><b><a href="details.html">/proc Information:</a></b>     <a href="#top">top</a><hr>
!
PROCFILES=`ls proc`
for FILE in $PROCFILES
do
   if test -f proc/$FILE
   then
      if [[ $cntr -lt 6 ]]
      then
         echo -n "<a href=\"proc/$FILE\">proc/$FILE</a>    " >> $DTL
         cntr=$[$cntr+1]
      else
         echo "<a href=\"proc/$FILE\">proc/$FILE</a>    " >> $DTL
         cntr=0
      fi
   fi
done
echo >> $DTL
echo "These files include CPU information, running modules, and (optionally) pci information as     " >> $DTL
echo "reported in the /proc filesystem.                                                             " >> $DTL
echo >> $DTL

if test -d proc/scsi
then
   if test -f proc/scsi/scsi
   then
      echo "<a href=\"proc/scsi/scsi\">proc/scsi/scsi</a>    " >> $DTL
      echo "A direcctory listing all devices scanned by the SCSI module as reported in the /proc filesystem. " >> $DTL
      echo >> $DTL
   fi
   TESTDIR=`ls proc/scsi/|grep qla2`
   if test -n "$TESTDIR"
   then
      for DIR in $TESTDIR
      do
         QLAFILE=`ls proc/scsi/$DIR/[0-9]*`
         for FILE in $QLAFILE
         do
            echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
         done
         echo >> $DTL
      done
      echo "QLogic FC driver instance files." >>$DTL
      echo >> $DTL
   else
      echo "No QLogic FC driver info found in /proc/scsi filesystem." >> $DTL
      echo >> $DTL
   fi
   TESTDIR=`ls proc/scsi/|grep qla4`
   if test -n "$TESTDIR"
   then
      for DIR in $TESTDIR
      do
         QLAFILE=`ls proc/scsi/$DIR/[0-9]*`
         for FILE in $QLAFILE
         do
            echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
         done
         echo >> $DTL
      done
      echo "QLogic iSCSI driver instance files." >>$DTL
      echo >> $DTL
   else
      echo "No QLogic iSCSI driver info found in /proc/scsi filesystem." >> $DTL
      echo >> $DTL
   fi
else
   echo "No SCSI info found in /proc filesystem." >> $DTL
   echo >> $DTL
fi

#
# Network Information
#
cat >> $DTL <<!
<hr><a id="etherinfo"></a><b><a href="details.html">Network Information:</a></b>     <a href="#top">top</a><hr>
!
echo -n  "<a href=\"network/ifconfig.out\">ifconfig -a</a>" >> $DTL
echo " : Interface configuration information">> $DTL

echo -n "<a href=\"network/netstat.out\">netstat -rn</a>" >> $DTL
echo " : IP Routing tables \(netstat\)" >> $DTL

echo -n "<a href=\"network/ip-route.out\">ip route</a>" >> $DTL
echo " : IP Routing tables \(ip\)" >> $DTL

echo -n "<a href=\"network/iptables.out\">iptables.out</a>" >> $DTL
echo " : Linux firewall configuration" >> $DTL

echo -n "<a href=\"network/iplinkshow.out\">ip -s link show</a>" >> $DTL
echo " : Link statistics" >> $DTL

if [ -f $LOGDIR/NetXtreme/ethtool.out ]
then
   echo -n "<a href=\"NetXtreme/ethtool.out\">ethtool output</a>" >> $DTL
   echo " : ethtool info for each network interface" >> $DTL
fi

echo >> $DTL

#if test $ETHERINSTALLED -eq 1
#then
#   QLETHERDRIVER=0
#   ETHDEVS=`grep "Link encap" $LOGDIR/network/ifconfig.out | cut -d " " -f1`
#   for file in $ETHDEVS
#   do
#      if test -f $LOGDIR/network/ethtool-i.$file
#      then
#         QLETHERDRIVER=1    
#         echo -n "<a href=\"network/ifconfig.$file\">network/ifconfig.$file</a>  " >> $DTL
#         echo -n "<a href=\"network/ethtool-i.$file\">network/ethtool-i.$file</a>  " >> $DTL
#         echo -n "<a href=\"network/ethtool-k.$file\">network/ethtool-k.$file</a>  " >> $DTL
#         echo "<a href=\"network/ethtool.$file\">network/ethtool.$file</a>" >> $DTL
#      fi
#   done
#   if test $QLETHERDRIVER -eq 1
#   then
#      echo "These files include details about specific QLogic network interfaces." >> $DTL
#   else
#      echo "No QLogic ethernet driver information available" >> $DTL
# DG bonding, netxen and vlan stuff goes here.
# Still need to add in the Netxen /proc/net/devX files in the format
# devX/file1 devX/file2 devX/file3 ... devX/file7
# devY/file1 devY/file2 devY/file3 ... devY/file7
# See ts80lx52/dev/sda13 and ts80lx56/dev/sdb1 for script outputs
#   fi
#else
#   echo "No QLogic Ethernet Adapters Detected in system" >> $DTL
#fi 
#echo >> $DTL

#
# QLogic Tools (SANsurfer/CLI) Info
#
cat >> $DTL <<!
<hr><a id="QLogic_tools"></a><b><a href="details.html">QLogic Tools (SANsurfer/CLI) Information:</a></b>     <a href="#top">top</a><hr>
!
#SMSINSTALL=`ls QLogic_tools/sansurfer*`
#for FILE in $SMSINSTALL
#do
#   echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
#done
#echo >> $DTL
#echo "SANsurfer GUI installation status and version information" >> $DTL
#echo >> $DTL

if [ -f $LOGDIR/QLogic_tools/scli.out ]
then
   SMSINSTALL=`ls QLogic_tools/*scli_install*`
   for FILE in $SMSINSTALL
   do
      echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
   done
   echo >> $DTL
   echo "SANsurfer CLI installation status and version information" >> $DTL
   echo >> $DTL
fi

SMSLISTS=`ls QLogic_tools/ls_*`
for FILE in $SMSLISTS
do
   echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
done
echo >> $DTL
echo "Directory listing of default SANsurfer GUI/CLI locations" >> $DTL
echo >> $DTL

if test -f QLogic_tools/scli.out
then
   echo -n "<a href=\"QLogic_tools/scli.out\">QLogic_tools/scli.out</a>    " >> $DTL
   echo " scli output for all FC Adapters." >> $DTL
   echo >> $DTL
fi
if test -f QLogic_tools/iscli.out
then
   echo -n "<a href=\"QLogic_tools/iscli.out\">QLogic_tools/iscli.out</a>    " >> $DTL
   echo "iscli output for all iSCSI Adapters." >> $DTL
   echo >> $DTL
fi

#
# System Log Information
#
cat >> $DTL <<!
<hr><a id="loginfo"></a><b><a href="details.html">System Log Information:</a></b>     <a href="#top">top</a><hr>
!
BOOTFILES=`ls logs/boot*`
for FILE in $BOOTFILES
do
   echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
done
echo >> $DTL
echo "Boot logs" >> $DTL
echo >> $DTL
MSGFILES=`ls logs/message* 2>> $LOGDIR/script/misc_err.log`
for FILE in $MSGFILES
do
   echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
done
echo >> $DTL
echo "System messages files" >> $DTL
echo >> $DTL
MSGFILES=`ls logs/* | grep -v "logs/message" | grep -v boot`
for FILE in $MSGFILES
do
   echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
done
echo >> $DTL
echo "Other log files" >> $DTL
echo >> $DTL

#
# Misc Information
#
cat >> $DTL <<!
<hr><a id="miscinfo"></a><b><a href="details.html">Miscellaneous Information:</a></b>     <a href="#top">top</a><hr>
!
echo -n "<a href=\"misc/fdisk.out\">misc/fdisk.out</a>     " >> $DTL
echo "<a href=\"misc/df.out\">misc/df.out</a>" >> $DTL
echo "List of devices recognized by the OS SCSI disk module and list of mounted disks." >> $DTL
echo >> $DTL
echo -n "<a href=\"misc/chkconfig.out\">misc/chkconfig.out</a>   " >> $DTL
echo "System runlevel configuration." >> $DTL
echo -n "<a href=\"misc/gcc.out\">misc/gcc.out</a>         " >> $DTL
echo "List of installed gcc binaries and version information." >> $DTL
echo -n "<a href=\"misc/lspci-v.out\">misc/lspci-v.out</a>       " >> $DTL
echo "List of hardware installed as reported by <i>lspci -v</i>" >> $DTL
echo -n "<a href=\"misc/dmidecode.out\">misc/dmidecode.out</a>   " >> $DTL
echo "Lists Motherboard and BIOS information as recognized by <i>dmidecode</i>" >> $DTL
echo -n "<a href=\"misc/ps.out\">misc/ps.out</a>          " >> $DTL
echo "List of all running processes." >> $DTL
echo -n "<a href=\"misc/uptime.out\">misc/uptime.out</a>      " >> $DTL
echo "System uptime." >> $DTL
echo -n "<a href=\"misc/ls_usrlib.out\">misc/ls_usrlib.out</a>   " >> $DTL
echo "32-bit Loadable libraries" >> $DTL
if test -f misc/ls_usrlib64.out
then
   echo -n "<a href=\"misc/ls_usrlib64.out\">misc/ls_usrlib64.out</a> " >> $DTL
   echo "64-bit Loadable libraries" >> $DTL
fi
echo >> $DTL
OTHERMISCFILES="misc/lsscsi.out misc/lsscsi_verbose.out misc/sysctl.out misc/vmstat.out misc/free.out misc/lsof.out"
for FILE in $OTHERMISCFILES
do
   if test -f $FILE
   then
      echo -n "<a href=\"$FILE\">$FILE</a>    " >> $DTL
   fi
done
echo >> $DTL
echo "Other miscellaneous files listing various system resources." >> $DTL
echo >> $DTL

#
# Wrap it up
#
cat >> $DTL <<!
<hr><a id="bottom"></a> <a href="#top">top</a><hr> 
<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br> 
</pre> 
</font> 
</body>
!
echo ... done

#####################################################################
# Create compressed archive of results ... then clean up
#####################################################################
echo -n "Creating compressed archive and cleaning up ... "

cd /tmp
tar czf $LOGNAME.tgz ./$LOGNAME
if test $? -ne 0 
then
   echo "*!*! Error while archiving the support data."
   echo "     Please tar and compress $LOGDIR by hand"
   echo "     and Email it to support@qlogic.com"
else
   rm -rf /tmp/$LOGNAME
   echo "done"
   echo
   echo "Please attach the file: $LOGDIR.tgz to your case at http://support.qlogic.com"
fi

#####################################################################
# All done ...
#####################################################################
exit
