# bootables

## Summary

Bash scripts to create bootable images on usb after downloading them. Mostly this consists of:

* [`bin/wget-image.sh`](../bin/wget-image.sh), a command line way of fetching (downloading) an (iso|usb|img) image given a url.

* [`bin/iso2usb.sh`](../bin/iso2usb.sh), a wrapper for `unetbootin` that burns an (iso|usb|image) to a usb stick. It's real value comes in finding the latest image downloaded and the latest usb stick plugged in. Then you don't have to go searching around for them.

## Workflow

```bash
wget-image.sh http://www.freedos.org/download/download/FD12CD.iso
# plug in a usb stick
usb2iso.sh # finds FD12CD.iso and /dev/sd? and feeds them to unetbootin
```

## Notes

This is pretty specific to my workflow.

`usb2iso.sh` also will look in `~/Downloads` for potential images. You will often use a web browser to download an image.

