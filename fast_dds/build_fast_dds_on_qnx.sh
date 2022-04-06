#!/bin/sh

# cdr_version="v1.0.24"
# foonathan_version="0.7-1"
# fast_dds_version="v2.6.0"

# if ! [ -f "$cdr_version.tar.gz" ]; then
#   curl -L --max-time 10 --retry 100 --retry-delay 1 https://github.com/eProsima/Fast-CDR/archive/refs/tags/$cdr_version.tar.gz -C - -o "$cdr_version.tar.gz"
# fi

# if [ $? -eq 0 ]; then
#   tar -xf $cdr_version.tar.gz  && \
#     cd Fast-CDR-1.0.24 && mkdir build && cd build && \
#     cmake -DCMAKE_TOOLCHAIN_FILE=$QNX_ROOT/cmake/QNXToolchain.cmake -DCMAKE_INSTALL_PREFIX=$QNX_TARGET/aarch64le/usr/ ../ &&
#     make -j16 && make install
# fi

# if [ $? -ne 0 ]; then
#   echo "Failed to build fast_cdr!"
#   exit $?
# fi

# if ! [ -f "v$foonathan_version.tar.gz" ]; then
#   curl -L --max-time 10 --retry 100 --retry-delay 1 https://github.com/foonathan/memory/archive/refs/tags/v$foonathan_version.tar.gz -C - -o "v$foonathan_version.tar.gz"
# fi

# if [ $? -eq 0 ]; then
#   tar -xf v$foonathan_version.tar.gz  && \
#     cd memory-$foonathan_version && mkdir build && cd build && \
#     cmake -DFOONATHAN_MEMORY_CONTAINER_NODE_SIZES_IMPL=../../foonathan_memory/qnx/aarch64/container_node_sizes_impl.hpp \
#       -DFOONATHAN_MEMORY_BUILD_EXAMPLES=OFF -DFOONATHAN_MEMORY_BUILD_TESTS=OFF -DCMAKE_BUILD_TYPE="Release" \
#       -DCMAKE_TOOLCHAIN_FILE=$QNX_ROOT/cmake/QNXToolchain.cmake -DCMAKE_INSTALL_PREFIX=$QNX_TARGET/aarch64le/usr/ ../ &&
#     make -j16 && make install
# fi

# if [ $? -ne 0 ]; then
#   echo "Failed to build foonathan_memory!"
#   exit $?
# fi

if ! [ -d "Fast-DDS" ]; then
  git clone --depth=1 --branch port/qnx https://github.com/c6supper/Fast-DDS.git && \
  cd Fast-DDS && git submodule update --init && cd ../;
fi

if [ $? -eq 0 ]; then
  # cd Fast-DDS/thirdparty/tinyxml2/ && rm -rf build && mkdir build && cd build && \
  #   cmake -DCMAKE_BUILD_TYPE="Release" \
  #     -DCMAKE_TOOLCHAIN_FILE=$QNX_ROOT/cmake/QNXToolchain.cmake -DCMAKE_INSTALL_PREFIX=$QNX_TARGET/aarch64le/usr/ ../ &&
  #   make -j16 && make install && \
  #   cd ../../asio/asio && ./autogen.sh && 
  cd Fast-DDS && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE="Release" -DTHIRDPARTY=ON -DCMAKE_CXX_FLAGS="-fpermissive" \
      -DCMAKE_TOOLCHAIN_FILE=$QNX_ROOT/cmake/QNXToolchain.cmake -DCMAKE_INSTALL_PREFIX=$QNX_TARGET/aarch64le/usr/ \
      -DCMAKE_SHARED_LINKER_FLAGS="-lsocket" -DFASTDDS_STATISTICS=ON \
	    -DOPENSSL_CRYPTO_LIBRARY=$QNX_TARGET/aarch64le/usr/lib/libcrypto.a \
	    -DOPENSSL_SSL_LIBRARY=$QNX_TARGET/aarch64le/usr/lib/libssl.a  ../ &&
      make -j64 && make install

fi

if [ $? -ne 0 ]; then
  echo "Failed to build fast dds!"
  exit $?
fi