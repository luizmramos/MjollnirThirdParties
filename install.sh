#!/bin/bash

set -e

if [ "$(id -u)" != "0" ]; then
	echo "Run this script with sudo."
	exit 1
fi

echo "==== Dependencies ===="
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install gcc-4.7 g++-4.7
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.7
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.6

apt-get install make cmake automake autoconf bison flex libevent-dev libboost1.48-dev libssl-dev mono-devel mono-gmcs pkg-config qt4-dev-tools zlibc zlib1g zlib1g-dev

echo "==== Cleaning ===="
rm -rf include
rm -rf lib
mkdir -p include
mkdir -p lib

echo "==== gflags ===="
cd gflags-2.1.1
rm -f CMakeCache.txt
cmake .
./configure || echo "No configure"
make
cp -r include/* ../include
cp lib/* ../lib
cd ..

echo "==== gtest ===="
cd gtest-1.7.0
rm -f CMakeCache.txt
cmake .
./configure
make
cp -r include/* ../include
cp lib/* ../lib
cp libgtest.a ../lib || cp lib/.libs/libgtest.a ../lib
cd ..

echo "==== thrift ===="
cd thrift-0.9.1
cp -f /usr/share/aclocal/pkg.m4 aclocal
autoconf
automake || echo ">>>> automake maybe failed"
./configure
make
make install
cp -r lib/py/build/lib.linux-x86_64-2.7/thrift ../lib/
cp lib/csharp/Thrift.dll ../lib/
cd ..
cp /usr/local/lib/libthrift.a lib/
cp -r /usr/local/include/thrift include/

