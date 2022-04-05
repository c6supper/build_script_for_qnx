#!/bin/sh

wget -c https://boostorg.jfrog.io/artifactory/main/release/1.78.0/source/boost_1_78_0.tar.bz2 && \
  tar -xf boost_1_78_0.tar.bz2 && \
  patch boost_1_78_0/boost/interprocess/permissions.hpp permissions.hpp.patch && \
  cd boost_1_78_0 && ./bootstrap.sh && \
  ./b2 --user-config=../qnx.jam --without-python target-os=qnx threading=multi variant=release link=shared install --prefix=$QNX_TARGET/aarch64le/usr