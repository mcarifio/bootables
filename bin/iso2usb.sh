#!/usr/bin/env bash

# iso2usb.sh is a wrapper for unetbootin. It uses some conventions to find the 

# me, the actual full path of this script.
me=$(readlink -e ${BASH_SOURCE})
# here, it's associated directory. Useful for constructing pathnames relative to this script.
here=$(dirname ${me})

# Look for image downloads in these directories if not passed as $1.
image_dir=$(readlink -e ${here}/../images)
downloads_dir=${HOME}/Downloads


# Find the newest file by creation date in a file tree matching a `find` pattern.
# Details: use regular expression matching using the egrep syntax. Print the pathname quoted in case it has embedded spaces. Gross.
# http://tldp.org/LDP/abs/html/internalvariables.html
# https://unix.stackexchange.com/questions/184863/what-is-the-meaning-of-ifs-n-in-bash-scripting
function newest_image {
    IFS=$'\n' # stop parsing whitespace in filenames
    (set +x; for f in $(find $1 -regextype egrep -regex '.*\.(iso|usb|img)$'; find $2 -regextype egrep -regex '.*\.(iso|usb|img)$') ; do stat --printf='%Y\t%n\n' $f; done | sort -g -r -k1 | head -1 | cut -f2 )

}

# Caller passed image pathname?
if [[ -z "$1" ]] ; then
    # No. Default to the newest downloaded image. You can change that value below.
    iso=$(newest_image ${image_dir} ${downloads_dir})
else
    # Yes. Use it.
    iso=$1
fi


# Caller passed a usb device name?
if [[ -z "$2" ]] ; then
    # No. There might be several devices to choose from. We assume the target is a usb stick ('block:scsi:usb').
    # Display all plugged in usb sticks. Let's the caller choose the right one below.
    echo "target usb drives:"
    lsblk --nodeps --scsi --output model,subsystems,path | grep 'block:scsi:usb'
    echo -e "\n"

    # targetdrive defaults to last usb device mounted (assumes lsblk lists them in chronological order).
    targetdrive=$(lsblk --nodeps --scsi --output model,subsystems,path | grep 'block:scsi:usb' | awk 'END {print $3}')
    if [[ -z "${targetdrive}" ]] ; then
        echo "No usb drive available?"
    else
        echo "guessing target: ${targetdrive}"
    fi
fi

# Using unetbootin, write the image ${iso} to drive ${targetdrive}. User must confirm the selection first.
# autoinstall=yes
# `sudo dd if=${iso} of=${targetdrive}` is an alternative to unetbootin for .img files.
# unetbootin assumes ${targetdrive} is a FAT fs. Dumb assumption.

# unetbootin might not be in root's path.
unb=$(type -p unetbootin)

# Exit status set by unetnbootin.
( set -x; sudo ${unb} installtype=USB targetdrive=${targetdrive} method=diskimage isofile=${iso} )

