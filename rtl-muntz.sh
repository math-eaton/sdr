#!/bin/bash

# Removes unneeded files.  Use option extglob to allow rm !()
shopt -s extglob

#   Remove everything in /usr/lib but x86...
cd /usr/lib
rm -rf !(x86_64-linux-gnu)

# remove all libraries except ...
cd /usr/lib/x86_64-linux-gnu
EXC="!(libc.*|ld-linux*"							# basic c library
#EXC+="|libtinfo*"									# needed for bash
#EXC+="|libselinux*|libacl.*|libattr.*|libpcre*"	# needed for cp
EXC+="|libresolv.*"									# needed for busybox
EXC+="|libusb*|libudev.*|libpthread.*|libm.*"		# needed for rtl_* programs
EXC+=")"
rm -fr $EXC

#   Nuke some misc stuff
rm -rf /var/lib/dpkg
rm -rf /var/lib/apt
rm -rf /var/cache/debconf
rm -rf /var/cache/apt
rm -rf /usr/share

# And last remove everything from sbin and bin except busybox.
cd /usr/sbin && rm !(nothing)
cd /usr/bin  && rm !(busybox)

