#
# author:	D.G. Adams 2023-09-30
#
# builds rtlsdr version 4 as an image.
# Meant to be used as an image to build other containers
# but can be run if a CMD is specified in the docker run
# or docker compose file.
#
# libraries are in /usr/local/lib
# and rtl-* executables are in /usr/local/bin
#
FROM debian:trixie-slim AS dga-build

WORKDIR /work
RUN <<EOR
    apt-get -yq update && \
    apt-get -yq install libusb-1.0-0-dev git cmake build-essential pkg-config && \
    git clone https://github.com/rtlsdrblog/rtl-sdr-blog
    cd rtl-sdr-blog
    mkdir build
    cd build
    cmake ../
    make
    make install
EOR
###############################

FROM debian:trixie-slim AS dga-filesystem
COPY --from=dga-build /usr/local/bin/* /usr/local/bin/
COPY --from=dga-build /usr/local/lib/librtlsdr.so.0.6git /usr/local/lib/
COPY muntz.sh /

RUN <<EOF
    apt-get -yq update
    apt-get -yq install libusb-1.0-0 busybox

	bash /muntz.sh
	busybox --install -s
	rm /muntz.sh

#   move libraries
    cd /usr/lib/x86_64-linux-gnu
    mv /usr/local/lib/librtlsdr.so.0.6git .
    ln -s librtlsdr.so.0.6git librtlsdr.so.0
    ln -s librtlsdr.so.0 librtlsdr.so
    chmod +x /usr/local/bin/*
EOF

##############################

FROM scratch AS dga-install
COPY --from=dga-filesystem / /
USER nobody

# No startup command.  Use the compose file to specify startup.
