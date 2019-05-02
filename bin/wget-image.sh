#!/usr/bin/env bash

# Download a url of a bootable .iso or .usb file to ../images/${name}/**
# Example usage: wget-image.sh http://www.freedos.org/download/download/FD12CD.iso

# me, the actual full path of this script.
me=$(readlink -e ${BASH_SOURCE})
# here, it's associated directory. Useful for constructing pathnames relative to this script.
here=$(dirname ${me})

# Break apart the url.
# Comment example: `http://www.freedos.org/download/download/FD12CD.iso`
url=${1:?'expecting a url'} ## url argument required

# Remove the prefix e.g. `http://www.freedos.org/download/download` yielding `FD12CD.iso`.
name=${url##*/}

# remove the suffix e.g. .iso
label=${name%%.*}

# Image downloads placed in a sibling `images` directory.
image_dir=${here}/../images/${label}

# Create the directory if it isn't there.
install -v -d ${image_dir}

# Clean up the directory pathname.
image_dir=$(readlink -e ${image_dir})

# Create a "redo" script if you ever want to get the image again.
script=${image_dir}/get-${name}.sh
echo -e "#!/usr/bin/env bash\nwget --xattr --continue --no-clobber --directory-prefix=${image_dir} ${url}" > ${script}
chmod a+x ${script}
if ${script} ; then
    echo "${label} ${url} ${image_dir}/${name}" >> ${me}.download.log
else
    echo "${script} exit status '$?'" > /dev/stderr
fi
exit 0
