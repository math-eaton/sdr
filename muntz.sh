#!/bin/bash

shopt -s extglob        # bash extension to allow rm -rf !(except_files|...)

# remove all libraries except ...
cd /usr/lib/x86_64-linux-gnu
	EXC="!(libc.*|ld-linux*|libresolv.*"
	EXC+="|libusb*|libudev.*|libpthread.*|libm.*)"		# needed for rtl_* programs
rm -fr $EXC

#   remove unneeded files and directories
cd /var         && rm -rf *
cd /etc         && rm !(group|passwd|shadow)
cd /usr         && rm -rf !(lib|bin|sbin|lib64|libexec|local)
cd /usr/lib     && rm -rf !(x86_64-linux-gnu)
cd /usr/sbin    && rm *
cd /usr/bin     && rm !(busybox)

