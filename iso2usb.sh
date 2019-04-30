#!/usr/bin/env bash

iso=${1:?'need an iso file'}
targetdrive=${2:-/dev/sdd1}
# autoinstall=yes
( set -x; sudo /opt/unetbootin/current/bin/unetbootin installtype=USB targetdrive=${targetdrive} method=diskimage isofile=${iso} )
