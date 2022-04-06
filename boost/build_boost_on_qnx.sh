#!/bin/sh

if ! [ -f ./boost_1_78_0.tar.bz2 ]; then
  curl -L --max-time 10 --retry 100 --retry-delay 1 https://boostorg.jfrog.io/artifactory/main/release/1.78.0/source/boost_1_78_0.tar.bz2 -C - -o boost_1_78_0.tar.bz2
fi

if [ $? -eq 0 ]; then
  tar -xf boost_1_78_0.tar.bz2 && \
    patch boost_1_78_0/boost/interprocess/permissions.hpp permissions.hpp.patch && \
    cd boost_1_78_0 && ./bootstrap.sh && \
    ./b2 --user-config=../qnx.jam --without-python target-os=qnx threading=multi variant=release link=shared install --prefix=$QNX_TARGET/aarch64le/usr
fi

if [ $? -ne 0 ]; then
  echo "Failed to build boost!"
fi