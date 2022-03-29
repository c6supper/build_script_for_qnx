#!/bin/sh

wget -c https://boostorg.jfrog.io/artifactory/main/release/1.78.0/source/boost_1_78_0.tar.gz && \
  tar -xf boost_1_78_0.tar.gz && \
  patch boost_1_78_0/boost/interprocess/permissions.hpp permissions.hpp.patch && \
  cd boost_1_78_0 && ./bootstrap.sh && \
  ./b2 --user-config=../qnx.jam --without-python target-os=qnx link=shared install --prefix=$QNX_TARGET/user