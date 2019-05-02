# images/**

This directory `images/` contains iso images fetched from the internet and burned onto usb drives, usually for booting PCs in various ways.
It's a convenience for [`bin/wget-image.sh`](../bin/wget-image.sh) to have a location to land images. [`bin/iso2usb.sh`](../bin/iso2usb.sh) looks
in this directory and `~/Downloads` to find images to burn to usb sticks. You can pass a pathname to `iso2usb.sh` directly (and hence it can be anywhere).
