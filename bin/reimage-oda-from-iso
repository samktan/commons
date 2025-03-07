#!/usr/bin/env sh

if [ -z $1 ]; then
	echo "Usage: ${0##*/} <ilom-hostname-or-IP>"
	exit 1
fi

ILOM=$1
ISO_FOLDER=$HOME/public_html/MOS_PATCHES

cd $ISO_FOLDER
PS3="Select ISO file [Ctrl-C to quit]: "
ISO_FILES=$(find . -name 'oda*.iso' -print | sort)
select ISO in ${ISO_FILES[@]}
do
	case "$ISO" in
		*) if [ -z $ISO ]; then exit 1; fi; ISO_PATH=$(realpath $ISO); break ;;
	esac
done

echo "ILOM: $ILOM"

echo "ISO: $ISO_PATH"
NFS="nfs://10.187.101.66:/homes/software/public_html/MOS_PATCHES/${ISO_PATH#*MOS_PATCHES/}"
echo "NFS: $NFS"
printf "Proceed? [YES or cancel]: "
read ACK

if [ "$ACK" != "YES" ]; then
	exit 1
fi

# THE POINT OF NO RETURN

ssh -l root $ILOM << EOF

show /SYS
stop -f /SYS
y

set /SP/services/kvms/host_storage_device mode=disabled
show /SP/services/kvms/host_storage_device

set /SP/services/kvms/host_storage_device/remote server_uri=$NFS
set /SP/services/kvms/host_storage_device mode=remote
show /SP/services/kvms/host_storage_device

set /HOST boot_device=cdrom

start /SYS
y

EOF

echo "${ILOM} ready to be re-imaged. Run 'cleanup.pl' to erase data on shared storage."

