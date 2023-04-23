#!/bin/bash

# This script will install all the requred software to run the benchmarks, doesn't matter if the
# node is used only to generate load, and therefore would only require memtier_benchmark, or if
# the node is used to run the server, and therefore would require all the server software (
# cachegrand, dragonfly, redis, keydb).

# Update the OS
sudo apt update && sudo apt upgrade -y

# Install all the required dependencies to build the software
sudo apt install \
    build-essential cmake pkg-config git \
    libnuma1 libnuma-dev \
    libcurl4-openssl-dev libcurl4 \
    libyaml-0-2 libyaml-dev \
    libmbedtls-dev libmbedtls14 \
    libpcre2-8-0 libpcre2-dev \
    libjson-c-dev \
    libhiredis-dev \
    liblzf-dev \
    autoconf \
    automake \
    libpcre3-dev \
    libevent-dev \
    libssl-dev \
    zlib1g-dev \
    ninja-build \
    libunwind-dev \
    libboost-fiber-dev \
    autoconf-archive \
    libtool \
    libzstd-dev \
    nasm \
    autotools-dev \
    libjemalloc-dev \
    tcl \
    tcl-dev \
    uuid-dev \
    libcurl4-openssl-dev \
    libbz2-dev \
    libzstd-dev \
    liblz4-dev \
    libsnappy-dev

# Build memtier_benchmark and install it
cd /root
mkdir dev
cd dev
git clone https://github.com/RedisLabs/memtier_benchmark.git
cd memtier_benchmark
autoreconf -ivf
./configure
make
sudo make install

# Build cachegrand, the binaries will be in /root/dev/cachegrand/cmake-build-release/src
cd /root
mkdir dev
cd dev
git clone -b v0.2.1 https://github.com/danielealbano/cachegrand.git
cd cachegrand
git submodule update --init --recursive
mkdir cmake-build-release
cd cmake-build-release
cmake .. -DCMAKE_BUILD_TYPE=Release -DUSE_HASH_ALGORITHM_T1HA2=1
make -j$(nproc)

# Build dragonfly, the binaries will be in /root/dev/dragonfly/build-opt/
cd /root
mkdir dev
cd dev
git clone -b v1.1.2 --recursive https://github.com/dragonflydb/dragonfly
cd dragonfly
./helio/blaze.sh -release
cd build-opt && ninja dragonfly

# Build redis, the binaries will be in /root/dev/redis/src
cd /root
mkdir dev
cd dev
git clone -b 7.0.11 --recursive https://github.com/redis/redis
cd redis
make -j$(nproc)

# Build keydb, the binaries will be in /root/dev/KeyDB/src
cd /root
mkdir dev
cd dev
git clone -b v6.3.2 --recursive https://github.com/Snapchat/KeyDB
cd KeyDB
make -j$(nproc)
