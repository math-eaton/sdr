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
FROM debian:bookworm-slim AS dga-build

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

FROM alpine:latest AS dga-filesystem
#FROM cgr.dev/chainguard/wolfi-base AS dga-filesystem
#FROM bellsoft/alpaquita-linux-base:stream-glibc AS dga-filesystem

WORKDIR /usr/local/bin
COPY --from=dga-build /usr/local/bin/* .
COPY rtl-tcp.sh .
WORKDIR /usr/local/lib
COPY --from=dga-build /usr/local/lib/librtlsdr.so.0.6git .
RUN <<EOR
    apk --no-cache add libusb gcompat bash
#    apk --no-cache add libusb bash
    ln -s librtlsdr.so.0.6git librtlsdr.so.0
    ln -s /librtlsdr.so.0 librtlsdr.so
    chmod +x /usr/local/bin/*
EOR
##############################

FROM scratch AS dga-install
COPY --from=dga-filesystem / /
USER nobody

# No startup command.  Use the compose file to specify startup.
