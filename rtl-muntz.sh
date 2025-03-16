#!/bin/bash
# This script uses a feature of bash - extglob which allows rm !(exception_list) to
# selectively remove any file in the current image layer except those listed.
# Used for muntzing libraries and files down to the minimal set needed to run the application.

shopt -s extglob

#   Remove everything in /usr/lib but x86...
	cd /usr/lib
	rm -rf !(x86_64-linux-gnu)

# 	remove all libraries except ...
	cd /usr/lib/x86_64-linux-gnu
	EXC="!(libc.*|ld-linux*"							# basic c library
#	EXC+="|libtinfo*"									# needed for bash
#	EXC+="|libselinux*|libacl.*|libattr.*|libpcre*"		# needed for cp
	EXC+="|libresolv.*"									# needed for busybox
	EXC+="|libusb*|libudev.*|libpthread.*|libm.*"		# needed for rtl_* programs
	EXC+=")"
	rm -fr $EXC

#   Nuke some misc stuff
#   Nuke anything not needed in the container
    cd /var && rm -rf !(nothing)
#    cd /etc && rm -rf apt dconf dpkg
    rm -rf -- /etc/*/
    cd /usr && rm -rf !(lib|bin|sbin|lib64|libexec|local)

# 	And last remove everything from sbin and bin except busybox.
	cd /usr/sbin && rm !(nothing)
	cd /usr/bin  && rm !(busybox)

