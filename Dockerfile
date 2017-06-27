# == Dockerized RTLSDR
#

FROM rtlsdr:latest

MAINTAINER Eric Faden <efaden@gmail.com>

ENV DEBIAN_FRONTEND="noninteractive" 

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install Required Stuff
RUN apt-get -y update && apt-get -y install \
    libtool \
    libusb-1.0.0-dev \
    librtlsdr-dev \
    cmake \
    git \
	&& rm -rf /var/lib/apt/lists/*

RUN cd / && \
  git clone https://github.com/merbanan/rtl_433.git && \
  cd rtl_433 && \
  mkdir build && \
  cd build && \
  cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON && \
  make && \
  make install && \
  cd / && \
  rm -rf rtl_433

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
